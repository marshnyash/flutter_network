import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3, // Default: retry 3 times
    this.retryInterval = const Duration(seconds: 2), // Default: 2 seconds between retries
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      var retryCount = 0;

      while (retryCount < maxRetries) {
        retryCount++;
        try {
          print('Retrying request... Attempt #$retryCount');
          await Future.delayed(retryInterval); // Wait before retrying
          final response = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              responseType: err.requestOptions.responseType,
              contentType: err.requestOptions.contentType,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          return handler.resolve(response); // Return the response if successful
        } catch (e) {
          print('Retry #$retryCount failed');
        }
      }
    }
    // If retries are exhausted, return the original error
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry for network or server-side errors (status codes not 200)
    return err.type == DioExceptionType.connectionError
     || err.response?.statusCode == null || (err.response?.statusCode ?? 0) != 200;
  }
}

class ApiService {
  final Dio _dio = Dio();

  ApiService({required String token}) {
    _dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add the retry interceptor
    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    // Add authorization token and other headers
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Set the Authorization token dynamically
        // options.headers['Authorization'] = 'Bearer $token';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options); // Continue with the request
      },
    ));
  }

  Future<Response> getData(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> deleteData(String endpoint) async {
    return await _dio.delete(endpoint);
  }
}
