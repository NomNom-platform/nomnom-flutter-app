import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/recommendation_remote_data_source.dart';
import '../../data/repositories/recommendation_repository_impl.dart';
import '../../domain/repositories/recommendation_repository.dart';

part 'recommendation_di.g.dart';

@Riverpod(keepAlive: true)
Dio recommendationDio(RecommendationDioRef ref) {
  return buildDioClient(AppConfig.recommendationServiceUrl, ref.watch(tokenStorageProvider));
}

@Riverpod(keepAlive: true)
RecommendationRemoteDataSource recommendationRemoteDataSource(RecommendationRemoteDataSourceRef ref) {
  return RecommendationRemoteDataSourceImpl(ref.watch(recommendationDioProvider));
}

@Riverpod(keepAlive: true)
RecommendationRepository recommendationRepository(RecommendationRepositoryRef ref) {
  return RecommendationRepositoryImpl(ref.watch(recommendationRemoteDataSourceProvider));
}
