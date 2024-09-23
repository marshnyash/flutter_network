import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {}

class SubmitPost extends PostsEvent {
  final String title;
  final String body;

  const SubmitPost({required this.title, required this.body});

  @override
  List<Object> get props => [title, body];
}

class DeletePost extends PostsEvent {
  final int id;

  const DeletePost(this.id);

  @override
  List<Object> get props => [id];
}
