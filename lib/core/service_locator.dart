import 'package:get_it/get_it.dart';
import 'package:network/bloc/posts_bloc.dart';
import 'package:network/network/api_service.dart';
import 'package:network/network/dio_service.dart';


final getIt = GetIt.instance;

void setupLocator() {
  // Register the DioService singleton
  getIt.registerLazySingleton(() => DioService(token: 'my_token_here'));

  // Register ApiService, using Dio from DioService
  getIt.registerFactory(() => ApiService(dio: getIt<DioService>().dio));

  // Register PostsBloc
  getIt.registerFactory(() => PostsBloc(getIt<ApiService>()));
}
