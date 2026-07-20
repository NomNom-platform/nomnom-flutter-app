import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_item.freezed.dart';

@freezed
class RecommendedItem with _$RecommendedItem {
  const factory RecommendedItem({
    required String itemId,
    required String name,
    int? calories,
    double? proteinG,
    double? carbG,
    double? fatG,
    required double price,
    required String reason,
  }) = _RecommendedItem;
}
