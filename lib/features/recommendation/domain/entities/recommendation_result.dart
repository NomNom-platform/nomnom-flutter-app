import 'package:freezed_annotation/freezed_annotation.dart';
import 'recommended_item.dart';

part 'recommendation_result.freezed.dart';

@freezed
class RecommendationResult with _$RecommendationResult {
  const factory RecommendationResult({
    required List<RecommendedItem> items,
    String? aiExplanation,
    required bool usedAi,
  }) = _RecommendationResult;
}
