// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restaurantControllerHash() =>
    r'b117ac2169a9c2b8ce227d08d84f8c985b660d44';

/// Owns the current owner's restaurant profile. `null` data means the owner
/// has not created a restaurant yet — callers should offer the create flow.
///
/// Copied from [RestaurantController].
@ProviderFor(RestaurantController)
final restaurantControllerProvider = AutoDisposeAsyncNotifierProvider<
    RestaurantController, Restaurant?>.internal(
  RestaurantController.new,
  name: r'restaurantControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$restaurantControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RestaurantController = AutoDisposeAsyncNotifier<Restaurant?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
