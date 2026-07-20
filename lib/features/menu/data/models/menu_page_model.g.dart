// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuPageModelImpl _$$MenuPageModelImplFromJson(Map<String, dynamic> json) =>
    _$MenuPageModelImpl(
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MenuItemModel>[],
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      last: json['last'] as bool? ?? true,
    );

Map<String, dynamic> _$$MenuPageModelImplToJson(_$MenuPageModelImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
