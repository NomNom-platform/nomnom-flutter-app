import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/meal_type.dart';
import '../../domain/entities/recommendation_history_page.dart';
import '../providers/recommendation_di.dart';
import '../state/recommendation_state.dart';

part 'recommendation_controller.g.dart';

@riverpod
class RecommendationController extends _$RecommendationController {
  @override
  RecommendationState build() => const RecommendationState();

  Future<void> generate({
    required String restaurantId,
    required MealType mealType,
    bool useAi = false,
  }) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(recommendationRepositoryProvider).getRecommendations(
          restaurantId: restaurantId,
          mealType: mealType,
          useAi: useAi,
        );
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (recommendation) => state = state.copyWith(isLoading: false, result: recommendation, failure: null),
    );
  }
}

@riverpod
Future<RecommendationHistoryPage> recommendationHistory(RecommendationHistoryRef ref) async {
  final result = await ref.watch(recommendationRepositoryProvider).getHistory();
  return result.fold((failure) => throw failure, (page) => page);
}
