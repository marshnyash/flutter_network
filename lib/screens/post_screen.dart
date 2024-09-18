import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/bloc/posts_bloc.dart';
import 'package:network/bloc/posts_event.dart';
import 'package:network/bloc/posts_state.dart';
import 'package:network/services/api_service.dart';

class PostScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String token = 'test_token';

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocProvider(
        create: (context) => PostBloc(ApiService(token: token)), 
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _bodyController,
                    decoration: const InputDecoration(labelText: 'Body'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PostBloc>(context).add(
                        SubmitPost(
                          title: _titleController.text,
                          body: _bodyController.text,
                        ),
                      );
                      
                      // Clear input fields after submission
                      _titleController.clear();
                      _bodyController.clear();
                    },
                    child: const Text('Submit Post'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              BlocProvider.of<PostBloc>(context).add(DeletePost(post.id));
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is PostError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Press button to fetch posts'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
