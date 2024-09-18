import 'package:get_it/get_it.dart';
import 'package:network/bloc/posts_bloc.dart';
import 'api_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register the ApiService singleton
  getIt.registerLazySingleton(() => ApiService(token: 'my_token_here'));

  // Register PostBloc, using ApiService from getIt
  getIt.registerFactory(() => PostBloc(getIt<ApiService>()));
}
