import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/restaurant.dart';

part 'restaurant_model.freezed.dart';
part 'restaurant_model.g.dart';

/// Wire format for `RestaurantResponse` from restaurant-service (:8082).
@freezed
class RestaurantModel with _$RestaurantModel {
  const RestaurantModel._();

  const factory RestaurantModel({
    required String id,
    required String ownerId,
    required String name,
    String? description,
    required String address,
    String? phone,
    String? cuisineType,
    String? imageUrl,
    required String status,
    String? rejectionReason,
    String? suspendReason,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Restaurant toEntity() => Restaurant(
        id: id,
        ownerId: ownerId,
        name: name,
        description: description ?? '',
        address: address,
        phone: phone ?? '',
        cuisineType: cuisineType ?? '',
        imageUrl: imageUrl,
        status: status,
        rejectionReason: rejectionReason,
        suspendReason: suspendReason,
      );
}
