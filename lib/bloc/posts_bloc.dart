import 'package:bloc/bloc.dart';
import 'package:network/bloc/posts_event.dart';
import 'package:network/bloc/posts_state.dart';
import 'package:network/services/api_service.dart';
import 'package:network/model/post_model.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService _apiService;

  PostBloc(this._apiService) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SubmitPost>(_onSubmitPost);
    on<DeletePost>(_onDeletePost);

    // Automatically fetch posts on initialization
    add(FetchPosts());
  }


  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final response = await _apiService.getData('/posts');
      final data = response.data as List;
      final posts = data.map((json) => Post.fromJson(json)).toList();
      emit(PostLoaded(posts: posts));
      print(state is PostLoaded );
    } catch (e) {
      emit(const PostError(message: 'Failed to load posts'));
    }
  }

Future<void> _onSubmitPost(SubmitPost event, Emitter<PostState> emit) async {
  print(event.title);
  print(state);
  if (state is PostLoaded) {
    final currentState = state as PostLoaded;
    emit(PostLoading());
    try {
      final response = await _apiService.postData('/posts', {
        'title': event.title,
        'body': event.body,
      });
      print(response.statusCode);
      if (response.statusCode == 201) {
        final newPost = Post.fromJson(response.data);
        // Add new post to the beginning of the list
        final updatedPosts = [newPost, ...currentState.posts];
        emit(PostLoaded(posts: updatedPosts));
      }
    } catch (e) {
      emit(const PostError(message: 'Failed to create post'));
    }
  }
}

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      emit(PostLoading());
      try {
        await _apiService.deleteData('/posts/${event.id}');
        final updatedPosts = currentState.posts.where((post) => post.id != event.id).toList();
        emit(PostLoaded(posts: updatedPosts));
      } catch (e) {
        emit(const PostError(message: 'Failed to delete post'));
      }
    }
  }
}
