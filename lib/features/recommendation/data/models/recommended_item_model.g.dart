// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedItemModelImpl _$$RecommendedItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedItemModelImpl(
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num?)?.toInt(),
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      carbG: (json['carbG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
      price: (json['price'] as num).toDouble(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$RecommendedItemModelImplToJson(
        _$RecommendedItemModelImpl instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'name': instance.name,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbG': instance.carbG,
      'fatG': instance.fatG,
      'price': instance.price,
      'reason': instance.reason,
    };
