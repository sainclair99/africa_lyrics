import 'dart:async';
import 'dart:io';
import 'package:afrikalyrics_mobile/api/token_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'interceptors/dio_connectivity_request_retrier.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_onconnectionstatechange_interceptor.dart';
import 'multipartfile_extended.dart';

String SERVER_URL = "https://api.afrikalyrics.com/api";
Options defaultOptions = new Options(
    responseType: ResponseType.json,
    contentType: 'application/json; charset=utf-8',
    headers: {"accept": "application/json"});

class ALApi {
  late Dio _dio;
  int retryCount = 0;
  static const MAX_RETRY = 3;
  late String _token;

  static final ALApi _singleton = ALApi._internal();
  factory ALApi() {
    return _singleton;
  }
  ALApi._internal();

  Dio dioInstance() {
    if (_dio == null) {
      _dio = new Dio(BaseOptions(baseUrl: SERVER_URL));
      _dio
        ..interceptors.addAll([
          LoggingInterceptor(),
          RetryOnConnectionChangeInterceptor(
            requestRetrier: DioConnectivityRequestRetrier(
              dio: Dio(),
              connectivity: Connectivity(),
            ),
          ),
          //  DioCacheManager(CacheConfig(baseUrl: SERVER_URL)).interceptor,
        ]);
      _dio.interceptors
          .add(DioCacheManager(CacheConfig(baseUrl: SERVER_URL)).interceptor);
      _dio.interceptors.add(
        InterceptorsWrapper(
          onError: (
            DioError error,
            ErrorInterceptorHandler handler,
          ) async {
            if (error.response?.statusCode == 403 ||
                error.response?.statusCode == 401) {
              try {
                if (retryCount > MAX_RETRY) {
                  retryCount = 0;
                  error;
                }
                retryCount++;
                print("Retry count $retryCount");
                _dio.lock();
                _dio.interceptors.errorLock.lock();
                _dio.interceptors.requestLock.lock();
                _dio.interceptors.responseLock.lock();
                RequestOptions options = error.response!.requestOptions;
                var token = await TokenManager().getToken(refresh: true);
                options.headers["Authorization"] = "Bearer " + token;
                _dio.unlock();
                _dio.interceptors.errorLock.unlock();
                _dio.interceptors.requestLock.unlock();
                _dio.interceptors.responseLock.unlock();
                //repeat the rquest

                if (options.data is FormData) {
                  FormData formData = FormData();
                  formData.fields.addAll(options.data.fields);
                  for (MapEntry mapFile in options.data.files) {
                    formData.files.add(MapEntry(
                      mapFile.key,
                      MultipartFileExtended.fromFileSync(
                          mapFile.value.filePath),
                    ));
                  }
                  options.data = formData;
                }
                _dio.request(options.path, options: options as Options);
              } catch (e) {
                print(e);
                _dio.unlock();
                _dio.interceptors.errorLock.unlock();
                _dio.interceptors.requestLock.unlock();
                _dio.interceptors.responseLock.unlock();
                error;
              }
            } else {
              error;
            }
          },
        ),
      );
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    return _dio;
  }

  Future<Response> postRequest(
    String path, {
    data,
    bool auth = true,
    Options? dioOptions,
    String? base,
  }) async {
    var options = dioOptions ?? defaultOptions;
    if (auth == true) {
      var token = await TokenManager().getToken();
      options.headers = {...?options.headers, 'Authorization': 'Bearer $token'};
    }
    return dioInstance().post(
      '$path',
      data: data,
      options: options,
    );
  }

  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool auth = true,
    Options? dioOptions,
    String? base,
  }) async {
    var options = dioOptions ?? defaultOptions;
    options.headers = {...?options.headers, 'accept': 'application/json'};
    if (auth == true) {
      var token = await TokenManager().getToken();
      options.headers = {...?options.headers, 'Authorization': 'Bearer $token'};
    }
    return dioInstance().get(
      '$path',
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delRequest(String path,
      {Map<String, dynamic>? queryParameters,
      required Map<String, dynamic> data,
      bool auth = true,
      Options? dioOptions}) async {
    var options = dioOptions ?? defaultOptions;
    options.headers = {...?options.headers, 'accept': 'application/json'};
    if (auth == true) {
      var token = await TokenManager().getToken();
      options.headers = {...?options.headers, 'Authorization': 'Bearer $token'};
    }
    return dioInstance().delete(
      '$path',
      queryParameters: queryParameters,
      data: data,
      options: options,
    );
  }

  Future<Response> putRequest(String path,
      {data, bool auth = true, Options? dioOptions}) async {
    var options = dioOptions ?? defaultOptions;
    options.headers = {...?options.headers, 'accept': 'application/json'};
    if (auth == true) {
      var token = await TokenManager().getToken();
      options.headers = {...?options.headers, 'Authorization': 'Bearer $token'};
    }
    return dioInstance().put(
      '$path',
      data: data,
      options: options,
    );
  }

  patchRequest(String path,
      {data, bool auth = true, Options? dioOptions}) async {
    var options = dioOptions ?? defaultOptions;
    options.headers = {...?options.headers, 'accept': 'application/json'};
    if (auth == true) {
      var token = await TokenManager().getToken();
      options.headers = {...?options.headers, 'Authorization': 'Bearer $token'};
    }
    return dioInstance().patch(
      '$path',
      data: data,
      options: options,
    );
  }
}
