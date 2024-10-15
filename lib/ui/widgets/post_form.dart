import 'package:flutter/material.dart';
import 'package:network/core/providers/posts_provider.dart';

class PostForm extends StatelessWidget {
  final PostsProvider provider;

  const PostForm({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();

    titleController.addListener(() {
      provider.validateForm(titleController.text, bodyController.text);
    });

    bodyController.addListener(() {
      provider.validateForm(titleController.text, bodyController.text);
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: 'Body'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: provider.isFormValid
                ? () {
                    provider.submitPost(titleController.text, bodyController.text);
                    titleController.clear();
                    bodyController.clear();
                  }
                : null,
            child: const Text('Submit Post'),
          ),
        ],
      ),
    );
  }
}
