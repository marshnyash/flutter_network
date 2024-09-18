import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}

class SubmitPost extends PostEvent {
  final String title;
  final String body;

  const SubmitPost({required this.title, required this.body});

  @override
  List<Object> get props => [title, body];
}

class DeletePost extends PostEvent {
  final int id;

  const DeletePost(this.id);

  @override
  List<Object> get props => [id];
}
