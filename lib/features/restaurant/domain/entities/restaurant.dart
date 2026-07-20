import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';

/// Restaurant profile owned by a RESTAURANT_OWNER account.
///
/// Mirrors the fields the `fe` frontend relies on from `RestaurantResponse`.
/// Operating hours are intentionally omitted — the web frontend does not
/// send or edit them, so we keep the Flutter client faithful to that flow.
@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    required String address,
    required String phone,
    required String cuisineType,
    String? imageUrl,
    required String status,
    String? rejectionReason,
    String? suspendReason,
  }) = _Restaurant;
}
