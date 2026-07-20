// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationResponseModelImpl _$$RecommendationResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationResponseModelImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => RecommendedItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiExplanation: json['aiExplanation'] as String?,
      usedAi: json['usedAi'] as bool,
    );

Map<String, dynamic> _$$RecommendationResponseModelImplToJson(
        _$RecommendationResponseModelImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'aiExplanation': instance.aiExplanation,
      'usedAi': instance.usedAi,
    };
