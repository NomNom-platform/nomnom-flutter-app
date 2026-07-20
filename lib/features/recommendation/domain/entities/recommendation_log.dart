import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_log.freezed.dart';

/// One past recommendation call, as returned by `GET /api/recommendations/history`.
@freezed
class RecommendationLog with _$RecommendationLog {
  const factory RecommendationLog({
    required String id,
    required String restaurantId,
    required String mealType,
    required List<String> recommendedItemIds,
    String? aiExplanation,
    required bool usedAi,
    required DateTime createdAt,
  }) = _RecommendationLog;
}
