// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

String? _parseId(dynamic value) => value?.toString();

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    @JsonKey(fromJson: _parseId) String? id, // Only from response
    required String menuItemId,
    required String name,
    required int quantity,
    required double unitPrice,
    required int calories,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}
