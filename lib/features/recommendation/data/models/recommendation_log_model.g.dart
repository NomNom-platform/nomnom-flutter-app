// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationLogModelImpl _$$RecommendationLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationLogModelImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      mealType: json['mealType'] as String,
      recommendedItemIds: (json['recommendedItemIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      aiExplanation: json['aiExplanation'] as String?,
      usedAi: json['usedAi'] as bool,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$RecommendationLogModelImplToJson(
        _$RecommendationLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'mealType': instance.mealType,
      'recommendedItemIds': instance.recommendedItemIds,
      'aiExplanation': instance.aiExplanation,
      'usedAi': instance.usedAi,
      'createdAt': instance.createdAt,
    };
