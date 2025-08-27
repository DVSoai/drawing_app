import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/source/local/storages/global_storage.dart';
import '../data/source/network/api.dart';
GetIt getIt = GetIt.instance;
class ServiceLocator {
  Future<void> servicesLocator() async {
    final storage = GlobalStorageImpl();
    await storage.init();
    getIt.registerSingleton<GlobalStorage>(storage);

    // Dio and API Client
    final dio = Dio();

    getIt.registerSingleton<ApiClient>(ApiClient(dio));
  }
}