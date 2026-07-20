import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/order_remote_data_source.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

part 'order_di.g.dart';

@Riverpod(keepAlive: true)
Dio orderDio(OrderDioRef ref) {
  return buildDioClient(AppConfig.orderServiceUrl, ref.watch(tokenStorageProvider));
}

@Riverpod(keepAlive: true)
OrderRemoteDataSource orderRemoteDataSource(OrderRemoteDataSourceRef ref) {
  return OrderRemoteDataSourceImpl(ref.watch(orderDioProvider));
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(
    ref.watch(orderRemoteDataSourceProvider),
  );
}
