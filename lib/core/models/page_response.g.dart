// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageResponseImpl<T> _$$PageResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$PageResponseImpl<T>(
      content: (json['content'] as List<dynamic>?)?.map(fromJsonT).toList() ??
          const [],
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      last: json['last'] as bool? ?? false,
    );

Map<String, dynamic> _$$PageResponseImplToJson<T>(
  _$PageResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
