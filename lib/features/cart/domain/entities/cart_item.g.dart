// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      restaurantId: json['restaurantId'] as String,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'menuItemId': instance.menuItemId,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'calories': instance.calories,
      'imageUrl': instance.imageUrl,
      'restaurantId': instance.restaurantId,
    };
