import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation_log.dart';

part 'recommendation_log_model.freezed.dart';
part 'recommendation_log_model.g.dart';

/// Mirrors `RecommendationLog` (Mongo doc) from `RecommendationController.java`.
/// `userId` is intentionally omitted — the client already knows who it is.
@freezed
class RecommendationLogModel with _$RecommendationLogModel {
  const RecommendationLogModel._();

  const factory RecommendationLogModel({
    required String id,
    required String restaurantId,
    required String mealType,
    required List<String> recommendedItemIds,
    String? aiExplanation,
    required bool usedAi,
    required String createdAt,
  }) = _RecommendationLogModel;

  factory RecommendationLogModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationLogModelFromJson(json);

  RecommendationLog toEntity() => RecommendationLog(
        id: id,
        restaurantId: restaurantId,
        mealType: mealType,
        recommendedItemIds: recommendedItemIds,
        aiExplanation: aiExplanation,
        usedAi: usedAi,
        createdAt: DateTime.parse(createdAt),
      );
}
