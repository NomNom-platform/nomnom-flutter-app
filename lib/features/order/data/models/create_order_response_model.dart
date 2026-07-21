import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_model.dart';

part 'create_order_response_model.freezed.dart';
part 'create_order_response_model.g.dart';

@freezed
class CreateOrderResponseModel with _$CreateOrderResponseModel {
  const factory CreateOrderResponseModel({
    required OrderModel order,
    String? paymentUrl,
  }) = _CreateOrderResponseModel;

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) => _$CreateOrderResponseModelFromJson(json);
}
