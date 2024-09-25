import 'package:get_it/get_it.dart';
import 'package:network/core/network/api_service.dart';
import 'package:network/core/network/dio_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => DioService(token: 'my_token_here'));
  getIt.registerFactory(() => ApiService(dio: getIt<DioService>().dio));
}
