import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/bloc/posts_bloc.dart';
import 'package:network/bloc/posts_event.dart';
import 'package:network/bloc/posts_state.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_validateFields);
    _bodyController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      isButtonEnabled = _titleController.text.isNotEmpty && _bodyController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Column(
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
                  onPressed: isButtonEnabled
                      ? () {
                          BlocProvider.of<PostsBloc>(context).add(
                            SubmitPost(
                              title: _titleController.text,
                              body: _bodyController.text,
                            ),
                          );
                          
                          _titleController.clear();
                          _bodyController.clear();
                        }
                      : null, 
                  child: const Text('Submit Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PostsBloc, PostsState>(
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
                            BlocProvider.of<PostsBloc>(context).add(DeletePost(post.id));
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
    );
  }
}
