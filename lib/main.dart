import 'package:flutter/material.dart';
import 'package:network/core/network/api_service.dart';
import 'package:network/core/providers/posts_provider.dart';
import 'package:network/ui/screens/posts_screen.dart';
import 'package:network/core/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostsProvider(apiService: getIt<ApiService>()),
        ),
      ],
      child: const MaterialApp(
        home: PostsScreen(),
      ),
    );
  }
}
