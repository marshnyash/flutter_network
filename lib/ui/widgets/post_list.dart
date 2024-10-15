import 'package:flutter/material.dart';
import 'package:network/core/providers/posts_provider.dart';

class PostList extends StatelessWidget {
  final PostsProvider provider;

  const PostList({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: provider.posts.length,
      itemBuilder: (context, index) {
        final post = provider.posts[index];
        final isDeleting = provider.deletingPosts.contains(post.id);

        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.body),
          trailing: isDeleting
              ? const CircularProgressIndicator(strokeWidth: 2)
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => provider.deletePost(post.id),
                ),
        );
      },
    );
  }
}
