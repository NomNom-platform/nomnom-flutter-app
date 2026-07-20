import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/menu_remote_data_source.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/repositories/menu_repository.dart';

part 'menu_di.g.dart';

@Riverpod(keepAlive: true)
Dio menuDio(MenuDioRef ref) {
  return buildDioClient(AppConfig.menuServiceUrl, ref.watch(tokenStorageProvider));
}

@Riverpod(keepAlive: true)
MenuRemoteDataSource menuRemoteDataSource(MenuRemoteDataSourceRef ref) {
  return MenuRemoteDataSourceImpl(ref.watch(menuDioProvider));
}

@Riverpod(keepAlive: true)
MenuRepository menuRepository(MenuRepositoryRef ref) {
  return MenuRepositoryImpl(ref.watch(menuRemoteDataSourceProvider));
}
