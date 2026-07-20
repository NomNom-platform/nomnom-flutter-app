import 'package:dio/dio.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/meal_type.dart';
import '../../domain/entities/recommendation_history_page.dart';
import '../../domain/entities/recommendation_result.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_data_source.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource _remote;

  const RecommendationRepositoryImpl(this._remote);

  @override
  Future<Result<RecommendationResult>> getRecommendations({
    required String restaurantId,
    required MealType mealType,
    bool useAi = false,
  }) async {
    try {
      final model = await _remote.getRecommendations(
        restaurantId: restaurantId,
        mealType: mealType.apiValue,
        useAi: useAi,
      );
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<RecommendationHistoryPage>> getHistory({int page = 0, int size = 10}) async {
    try {
      final model = await _remote.getHistory(page: page, size: size);
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }
}
