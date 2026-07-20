import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/restaurant_remote_data_source.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../domain/repositories/restaurant_repository.dart';

part 'restaurant_di.g.dart';

@Riverpod(keepAlive: true)
Dio restaurantDio(RestaurantDioRef ref) {
  return buildDioClient(AppConfig.restaurantServiceUrl, ref.watch(tokenStorageProvider));
}

@Riverpod(keepAlive: true)
RestaurantRemoteDataSource restaurantRemoteDataSource(RestaurantRemoteDataSourceRef ref) {
  return RestaurantRemoteDataSourceImpl(ref.watch(restaurantDioProvider));
}

@Riverpod(keepAlive: true)
RestaurantRepository restaurantRepository(RestaurantRepositoryRef ref) {
  return RestaurantRepositoryImpl(ref.watch(restaurantRemoteDataSourceProvider));
}
