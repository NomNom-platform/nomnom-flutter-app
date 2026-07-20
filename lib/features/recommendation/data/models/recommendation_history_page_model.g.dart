// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_history_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationHistoryPageModelImpl
    _$$RecommendationHistoryPageModelImplFromJson(Map<String, dynamic> json) =>
        _$RecommendationHistoryPageModelImpl(
          content: (json['content'] as List<dynamic>)
              .map((e) =>
                  RecommendationLogModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          number: (json['number'] as num).toInt(),
          size: (json['size'] as num).toInt(),
          totalElements: (json['totalElements'] as num).toInt(),
          totalPages: (json['totalPages'] as num).toInt(),
          last: json['last'] as bool,
        );

Map<String, dynamic> _$$RecommendationHistoryPageModelImplToJson(
        _$RecommendationHistoryPageModelImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'number': instance.number,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
