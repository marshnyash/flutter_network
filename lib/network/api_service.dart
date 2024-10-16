import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network/network/api_endpoints.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3, 
    this.retryInterval = const Duration(seconds: 2), 
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      retryCount++;
      err.requestOptions.extra['retryCount'] = retryCount;

      debugPrint('Retrying request... Attempt #$retryCount');

      await Future.delayed(retryInterval);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response); 
      } catch (e) {
        debugPrint('Retry #$retryCount failed with error: $e');
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

class ApiService {
  final Dio _dio;

  ApiService({required Dio dio}) : _dio = dio;

  Future<Response> getData() async {
    return await _dio.get(ApiEndpoints.posts);
  }

  Future<Response> postData(Map<String, dynamic> data) async {
    return await _dio.post(ApiEndpoints.posts, data: data);
  }

  Future<Response> deleteData(int id) async {
    return await _dio.delete('${ApiEndpoints.posts}/$id');
  }
}
