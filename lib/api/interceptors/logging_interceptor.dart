import 'package:dio/dio.dart';
import 'package:json_pretty/json_pretty.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      prettyPrintJson({
        "base_url": options.baseUrl,
        "url": options.path,
        "method": options.method,
        "params": options.queryParameters,
        "body": options.data,
        'headers': options.headers.toString(),
      });
    } catch (e) {}

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    prettyPrintJson({
      "base_url": err.requestOptions.baseUrl,
      "path": err.requestOptions.path,
      "method": err.requestOptions.method,
      "data": err.requestOptions.data,
      "params": err.requestOptions.queryParameters,
      "original": err.message,
      "error": err.error.toString(),
      'headers': err.requestOptions.headers.toString(),
    });
    
    handler.next(err);
  }
}
