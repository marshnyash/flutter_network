import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/bloc/posts_bloc.dart';
import 'package:network/screens/posts_screen.dart';
import 'package:network/core/service_locator.dart';


void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => getIt<PostsBloc>(),
        child: const PostsScreen(),
      ),
    );
  }
}
