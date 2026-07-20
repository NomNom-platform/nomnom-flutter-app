import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String customerId,
    required String restaurantId,
    @Default(OrderStatus.pending) OrderStatus status,
    required double totalAmount,
    required String deliveryAddress,
    String? note,
    String? createdAt,
    String? updatedAt,
    @Default([]) List<OrderItemModel> items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}
