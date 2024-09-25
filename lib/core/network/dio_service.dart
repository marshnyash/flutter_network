import 'package:dio/dio.dart';
import 'package:network/core/network/api_endpoints.dart';
import 'package:network/core/network/retry_interceptor.dart';

class DioService {
  final Dio _dio;

  DioService({required String token})
      : _dio = Dio() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add the retry interceptor
    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    // Add headers
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
