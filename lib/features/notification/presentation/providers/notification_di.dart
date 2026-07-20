import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notification_di.g.dart';

@Riverpod(keepAlive: true)
Dio notificationDio(NotificationDioRef ref) {
  return buildDioClient(AppConfig.notificationServiceUrl, ref.watch(tokenStorageProvider));
}

@Riverpod(keepAlive: true)
NotificationRemoteDataSource notificationRemoteDataSource(NotificationRemoteDataSourceRef ref) {
  return NotificationRemoteDataSourceImpl(ref.watch(notificationDioProvider));
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepositoryImpl(ref.watch(notificationRemoteDataSourceProvider));
}
