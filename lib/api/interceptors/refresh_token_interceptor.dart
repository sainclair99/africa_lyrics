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
    if (error.response?.statusCode == 403 ||
        error.response?.statusCode == 401) {
      try {
        dio.lock();
        dio.interceptors.errorLock.lock();
        dio.interceptors.requestLock.lock();
        dio.interceptors.responseLock.lock();
        RequestOptions options = error.response!.requestOptions;
        var token = await tokenFuture();
        options.headers["Authorization"] = "Bearer " + token;
        dio.unlock();
        dio.interceptors.errorLock.unlock();
        dio.interceptors.requestLock.unlock();
        dio.interceptors.responseLock.unlock();
        dio.request(options.path, options: options as Options);
      } catch (e) {
        print(e);
        dio.unlock();
        dio.interceptors.errorLock.unlock();
        dio.interceptors.requestLock.unlock();
        dio.interceptors.responseLock.unlock();
        handler.next(error);
      }
    } else {
      handler.next(error);
    }
  }
}
