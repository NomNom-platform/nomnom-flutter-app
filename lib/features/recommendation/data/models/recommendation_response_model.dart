import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation_result.dart';
import 'recommended_item_model.dart';

part 'recommendation_response_model.freezed.dart';
part 'recommendation_response_model.g.dart';

/// Mirrors `RecommendationResponse` from `RecommendationController.java`.
@freezed
class RecommendationResponseModel with _$RecommendationResponseModel {
  const RecommendationResponseModel._();

  const factory RecommendationResponseModel({
    required List<RecommendedItemModel> items,
    String? aiExplanation,
    required bool usedAi,
  }) = _RecommendationResponseModel;

  factory RecommendationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseModelFromJson(json);

  RecommendationResult toEntity() => RecommendationResult(
        items: items.map((e) => e.toEntity()).toList(),
        aiExplanation: aiExplanation,
        usedAi: usedAi,
      );
}
