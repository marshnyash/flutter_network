// 


import 'package:equatable/equatable.dart';
import 'package:network/model/post_model.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostsState {}

class PostLoading extends PostsState {}

class PostLoaded extends PostsState {
  final List<Post> posts;

  const PostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostError extends PostsState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object> get props => [message];
}

