// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantModelImpl _$$RestaurantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantModelImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      cuisineType: json['cuisineType'] as String?,
      imageUrl: json['imageUrl'] as String?,
      status: json['status'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      suspendReason: json['suspendReason'] as String?,
    );

Map<String, dynamic> _$$RestaurantModelImplToJson(
        _$RestaurantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'cuisineType': instance.cuisineType,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'suspendReason': instance.suspendReason,
    };
