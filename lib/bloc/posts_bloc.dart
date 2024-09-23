import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:network/bloc/posts_event.dart';
import 'package:network/bloc/posts_state.dart';
import 'package:network/network/api_service.dart';
import 'package:network/model/post_model.dart';
import 'package:network/helper/errors_handler.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final ApiService _apiService;
  final ErrorHandler _errorHandler;

  PostsBloc(this._apiService) : _errorHandler = ErrorHandler(), super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SubmitPost>(_onSubmitPost);
    on<DeletePost>(_onDeletePost);

    // Automatically fetch posts on initialization
    add(FetchPosts());
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    emit(PostLoading());
    try {
      final response = await _apiService.getData();
      final data = response.data as List;
      final posts = data.map((json) => Post.fromJson(json)).toList();
      emit(PostLoaded(posts: posts));
      debugPrint('state is PostLoaded1: ${state is PostLoaded}');
    } catch (e) {
      emit(PostError(message: _errorHandler.getMessage(e)));
    }
  }

Future<void> _onSubmitPost(SubmitPost event, Emitter<PostsState> emit) async {
  debugPrint(event.title);
  debugPrint('state is PostLoaded2: ${state is PostLoaded}');
  if (state is PostLoaded) {
    final currentState = state as PostLoaded;
    emit(PostLoading());
    try {
      final response = await _apiService.postData({
        'title': event.title,
        'body': event.body,
      });
      debugPrint('Response status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        final newPost = Post.fromJson(response.data);
        final updatedPosts = [newPost, ...currentState.posts];
        emit(PostLoaded(posts: updatedPosts));
      }
    } catch (e) {
      emit(PostError(message: _errorHandler.getMessage(e)));
    }
  }
}

  Future<void> _onDeletePost(DeletePost event, Emitter<PostsState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      emit(PostLoading());
      try {
        await _apiService.deleteData(event.id);
        final updatedPosts = currentState.posts.where((post) => post.id != event.id).toList();
        emit(PostLoaded(posts: updatedPosts));
      } catch (e) {
        emit(PostError(message: _errorHandler.getMessage(e)));
      }
    }
  }
}
