// import 'package:flutter/material.dart';
// import 'package:network/core/providers/posts_provider.dart';
// import 'package:network/ui/widgets/post_form.dart';
// import 'package:network/ui/widgets/post_list.dart';
// import 'package:provider/provider.dart';

// class PostsScreen extends StatefulWidget {
//   const PostsScreen({super.key});

//   @override
//   State<PostsScreen> createState() => _PostsScreenState();
// }

// class _PostsScreenState extends State<PostsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final postProvider = Provider.of<PostsProvider>(context, listen: false);
//     postProvider.fetchPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final postProvider = Provider.of<PostsProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Posts')),
//       body: _postsBody(postProvider),
//     );
//   }


//   Widget _postsBody(PostsProvider provider) {
//     switch (provider.state) {
//       case PostsState.loading:
//         return const Center(child: CircularProgressIndicator());
//       case PostsState.error:
//         return Column(
//           children: [
//             PostForm(provider: provider),
//             Center(child: Text(provider.errorMessage ?? 'An error occurred.'))
//           ],
//         );
//       case PostsState.success:
//         return Column(
//           children: [
//             PostForm(provider: provider),
//             Expanded(child: PostList(provider: provider)),
//           ],
//         );
//       default:
//         return Container();
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:network/core/providers/posts_provider.dart';
// import 'package:network/ui/widgets/post_form.dart';
// import 'package:network/ui/widgets/post_list.dart';
// import 'package:provider/provider.dart';

// class PostsScreen extends StatefulWidget {
//   const PostsScreen({super.key});

//   @override
//   State<PostsScreen> createState() => _PostsScreenState();
// }

// class _PostsScreenState extends State<PostsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final postProvider = Provider.of<PostsProvider>(context, listen: false);
//     postProvider.fetchPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final postProvider = Provider.of<PostsProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Posts')),
//       body: _postsBody(postProvider),
//     );
//   }

//   Widget _postsBody(PostsProvider provider) {
//     switch (provider.state) {
//       case PostsState.loading:
//         return const Center(child: CircularProgressIndicator());
//       case PostsState.error:
//         return Column(
//           children: [
//             PostForm(provider: provider),
//             Center(child: Text(provider.errorMessage ?? 'An error occurred.'))
//           ],
//         );
//       case PostsState.success:
//         return Column(
//           children: [
//             PostForm(provider: provider),
//             Expanded(child: PostList(provider: provider)),
//           ],
//         );
//       default:
//         return Container();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:network/core/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final postProvider = Provider.of<PostsProvider>(context, listen: false);
    postProvider.fetchPosts();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: postProvider.state == PostsState.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        onChanged: (value) {
                          postProvider.validateForm(
                              value, _bodyController.text);
                        },
                      ),
                      TextField(
                        controller: _bodyController,
                        decoration: const InputDecoration(labelText: 'Body'),
                        onChanged: (value) {
                          postProvider.validateForm(
                              _titleController.text, value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      if (postProvider.errorMessage != null) ...[
                        Text(
                          postProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      ElevatedButton(
                        onPressed: postProvider.isFormValid
                            ? () {
                                postProvider.submitPost(
                                  _titleController.text,
                                  _bodyController.text,
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
                  child: ListView.builder(
                    itemCount: postProvider.posts.length,
                    itemBuilder: (context, index) {
                      final post = postProvider.posts[index];
                      final isDeleting =
                          postProvider.deletingPosts.contains(post.id);

                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                        trailing: isDeleting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  postProvider.deletePost(post.id);
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
