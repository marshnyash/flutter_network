import 'package:flutter/material.dart';
import 'package:network/core/helper/errors_handler.dart';
import 'package:network/core/model/post_model.dart';
import 'package:network/core/network/api_service.dart';

enum PostsState { initial, loading, error, success }

class PostsProvider with ChangeNotifier {
  final ApiService apiService;
  final ErrorsHandler _errorHandler = ErrorsHandler();
  final Set<int> _deletingPosts = {};
  
  List<Post> _posts = [];
  String? _errorMessage;
  PostsState _state = PostsState.initial;

  bool _isFormValid = false;

  PostsProvider({required this.apiService});

  List<Post> get posts => _posts;
  String? get errorMessage => _errorMessage;
  Set<int> get deletingPosts => _deletingPosts;
  PostsState get state => _state;
  bool get isFormValid => _isFormValid;

  void _setState(PostsState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    _setState(PostsState.loading);
    try {
      final response = await apiService.getPosts();
      _posts = (response.data as List).map((post) => Post.fromJson(post)).toList();
      _setState(PostsState.success);
    } catch (e) {
      _setState(PostsState.error);
      _errorMessage = _errorHandler.getMessage(e);
    }
  }

  Future<void> submitPost(String title, String body) async {
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await apiService.addPost({'title': title, 'body': body});
      final newPost = Post.fromJson(response.data);
      _posts.insert(0, newPost);
    } catch (e) {
      _setState(PostsState.error);
      _errorMessage = _errorHandler.getMessage(e);
    }
    notifyListeners();
  }

  Future<void> deletePost(int id) async {
    _deletingPosts.add(id);
    notifyListeners();
    try {
      await apiService.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
    } catch (e) {
      _setState(PostsState.error);
      _errorMessage = _errorHandler.getMessage(e);
    } finally {
      _deletingPosts.remove(id);
      notifyListeners();
    }
  }

  void validateForm(String title, String body) {
    _isFormValid = title.isNotEmpty && body.isNotEmpty;
    notifyListeners();
  }
}
