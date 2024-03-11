import 'dart:io';
import 'package:dio/dio.dart';

import 'dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({required this.requestRetrier});

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    if (_shouldRetry(err)) {
      try {
        requestRetrier.scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        // handler.next(e);
        print(e.toString());
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioError err) {
    return err.error != null &&
        err.error is SocketException;
  }
}
