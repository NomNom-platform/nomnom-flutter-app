// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderRequestModelImpl _$$OrderRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderRequestModelImpl(
      restaurantId: json['restaurantId'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      note: json['note'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderRequestModelImplToJson(
        _$OrderRequestModelImpl instance) =>
    <String, dynamic>{
      'restaurantId': instance.restaurantId,
      'deliveryAddress': instance.deliveryAddress,
      'note': instance.note,
      'items': instance.items,
    };
