import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommended_item.dart';

part 'recommended_item_model.freezed.dart';
part 'recommended_item_model.g.dart';

/// Mirrors `RecommendedItem` from `RecommendationController.java`.
@freezed
class RecommendedItemModel with _$RecommendedItemModel {
  const RecommendedItemModel._();

  const factory RecommendedItemModel({
    required String itemId,
    required String name,
    int? calories,
    double? proteinG,
    double? carbG,
    double? fatG,
    required double price,
    required String reason,
  }) = _RecommendedItemModel;

  factory RecommendedItemModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendedItemModelFromJson(json);

  RecommendedItem toEntity() => RecommendedItem(
        itemId: itemId,
        name: name,
        calories: calories,
        proteinG: proteinG,
        carbG: carbG,
        fatG: fatG,
        price: price,
        reason: reason,
      );
}
