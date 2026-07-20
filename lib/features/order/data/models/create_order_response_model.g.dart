// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderResponseModelImpl _$$CreateOrderResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderResponseModelImpl(
      order: OrderModel.fromJson(json['order'] as Map<String, dynamic>),
      paymentUrl: json['paymentUrl'] as String?,
    );

Map<String, dynamic> _$$CreateOrderResponseModelImplToJson(
        _$CreateOrderResponseModelImpl instance) =>
    <String, dynamic>{
      'order': instance.order,
      'paymentUrl': instance.paymentUrl,
    };
