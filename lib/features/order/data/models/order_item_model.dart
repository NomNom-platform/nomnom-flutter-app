import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    String? id, // Only from response
    required String menuItemId,
    required String name,
    required int quantity,
    required double unitPrice,
    required int calories,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}
