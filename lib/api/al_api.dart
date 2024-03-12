import 'dart:async';
import 'dart:io';
import 'package:afrikalyrics_mobile/api/token_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
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


  ALApi._internal() {
    // if (_dio == null) {

      _dio = Dio(BaseOptions(baseUrl: SERVER_URL));
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
      // _dio.interceptors
      //     .add(DioCacheManager(CacheConfig(baseUrl: SERVER_URL)).interceptor);


      _dio.interceptors.add(
        QueuedInterceptorsWrapper(
          onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
            // No changes needed for onRequest in this example
            return handler.next(options); // Pass request to next interceptor
          },
          onError: (DioError error, ErrorInterceptorHandler handler) async {
            if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
              try {
                if (retryCount > MAX_RETRY) {
                  retryCount = 0;
                  return handler.next(error); // Pass error to next interceptor
                }
                retryCount++;
                print("Retry count $retryCount");

                // Locks are no longer needed in Dio 5.0

                RequestOptions updatedOptions = error.requestOptions;
                var token = await TokenManager().getToken(refresh: true);
                updatedOptions.headers["Authorization"] = "Bearer $token";

                // Repeat request with updated authorization header
                if (updatedOptions.data is FormData) {
                  // Handle FormData with files if necessary
                  // ... (as in the original code)
                }

                final response = await _dio.fetch(updatedOptions);
                return handler.resolve(response); // Pass successful response back
              } catch (e) {
                print(e);
                return handler.next(error); // Pass error to next interceptor
              }
            } else {
              return handler.next(error); // Pass error to next interceptor
            }
          },
        ),
      );


      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {

          final SecurityContext securityContext = SecurityContext();
          HttpClient client = HttpClient(context: securityContext);

          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    // }

      // Cache interceptor
     getTemporaryDirectory().then((cacheDir) {
       _dio.interceptors.add(DioCacheInterceptor(options: CacheOptions(
         store: HiveCacheStore(
           cacheDir.path,
           hiveBoxName: 'dio_cache',
         ),
         policy: CachePolicy.forceCache,
         priority: CachePriority.high,
         maxStale: const Duration(minutes: 5),
         hitCacheOnErrorExcept: [401, 404],
         keyBuilder: (request) {
           return request.uri.toString();
         },
         allowPostMethod: false,
       )));

     });
  }

  Dio dioInstance()  {
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
      "$path",
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
