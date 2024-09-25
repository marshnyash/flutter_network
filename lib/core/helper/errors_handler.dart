import 'package:dio/dio.dart';

class ErrorsHandler {
  String getMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return 'No Internet connection. Please try again.';
        case DioExceptionType.connectionTimeout:
          return 'Request timed out. Please try again later.';
        case DioExceptionType.badResponse:
          return 'Error: ${error.response?.statusCode} - ${error.response?.statusMessage}';
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
