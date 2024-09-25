import 'package:dio/dio.dart';
import 'package:network/core/network/api_endpoints.dart';

class ApiService {
  final Dio _dio;

  ApiService({required Dio dio}) : _dio = dio;

  Future<Response> getPosts() async {
    return await _dio.get(ApiEndpoints.posts);
  }

  Future<Response> addPost(Map<String, dynamic> data) async {
    return await _dio.post(ApiEndpoints.posts, data: data);
  }

  Future<Response> deletePost(int id) async {
    return await _dio.delete('${ApiEndpoints.posts}/$id');
  }
}

