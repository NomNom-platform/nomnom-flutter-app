import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item_model.dart';

part 'order_request_model.freezed.dart';
part 'order_request_model.g.dart';

@freezed
class OrderRequestModel with _$OrderRequestModel {
  const factory OrderRequestModel({
    required String restaurantId,
    required String deliveryAddress,
    String? note,
    @Default([]) List<OrderItemModel> items,
  }) = _OrderRequestModel;

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) => _$OrderRequestModelFromJson(json);
}
