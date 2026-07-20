import '../../../../core/utils/result.dart';
import '../entities/meal_type.dart';
import '../entities/recommendation_history_page.dart';
import '../entities/recommendation_result.dart';

abstract class RecommendationRepository {
  Future<Result<RecommendationResult>> getRecommendations({
    required String restaurantId,
    required MealType mealType,
    bool useAi = false,
  });

  Future<Result<RecommendationHistoryPage>> getHistory({int page = 0, int size = 10});
}
