import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends QueuedInterceptor {
  final Dio dio;
  final Future<String> Function() tokenFuture;

  RefreshTokenInterceptor({required this.tokenFuture, required this.dio});
  @override
  void onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
      try {
        // Locks are no longer needed in Dio 5.0
        RequestOptions options = error.response!.requestOptions;
        var token = await tokenFuture();
        options.headers["Authorization"] = "Bearer $token";

        final response = await dio.fetch(options);
        return handler.resolve(response); // Pass successful response back
      } catch (e) {
        print(e);
        return handler.next(error); // Pass error to next interceptor
      }
    } else {
      handler.next(error);
    }
  }
}
