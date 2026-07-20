// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemModelImpl _$$MenuItemModelImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemModelImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as num,
      calories: (json['calories'] as num?)?.toInt(),
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      carbG: (json['carbG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool?,
    );

Map<String, dynamic> _$$MenuItemModelImplToJson(_$MenuItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbG': instance.carbG,
      'fatG': instance.fatG,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
    };
