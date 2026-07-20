import 'package:dio/dio.dart';
import '../models/recommendation_history_page_model.dart';
import '../models/recommendation_response_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<RecommendationResponseModel> getRecommendations({
    required String restaurantId,
    required String mealType,
    required bool useAi,
  });

  Future<RecommendationHistoryPageModel> getHistory({required int page, required int size});
}

class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  final Dio _dio;

  const RecommendationRemoteDataSourceImpl(this._dio);

  @override
  Future<RecommendationResponseModel> getRecommendations({
    required String restaurantId,
    required String mealType,
    required bool useAi,
  }) async {
    final response = await _dio.post('/api/recommendations', data: {
      'restaurantId': restaurantId,
      'mealType': mealType,
      'useAi': useAi,
    });
    return RecommendationResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RecommendationHistoryPageModel> getHistory({required int page, required int size}) async {
    final response = await _dio.get('/api/recommendations/history', queryParameters: {
      'page': page,
      'size': size,
    });
    return RecommendationHistoryPageModel.fromJson(response.data as Map<String, dynamic>);
  }
}
