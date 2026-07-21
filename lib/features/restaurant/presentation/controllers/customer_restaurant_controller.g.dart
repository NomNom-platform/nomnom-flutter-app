// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerRestaurantsHash() =>
    r'9d41024167a2e3be7634dd4473a231d5dd97c524';

/// See also [CustomerRestaurants].
@ProviderFor(CustomerRestaurants)
final customerRestaurantsProvider = AutoDisposeAsyncNotifierProvider<
    CustomerRestaurants, List<Restaurant>>.internal(
  CustomerRestaurants.new,
  name: r'customerRestaurantsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerRestaurantsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerRestaurants = AutoDisposeAsyncNotifier<List<Restaurant>>;
String _$restaurantDetailHash() => r'e666bba304fc425129aa6bdf02163c021b4f5b29';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RestaurantDetail
    extends BuildlessAutoDisposeAsyncNotifier<Restaurant> {
  late final String restaurantId;

  FutureOr<Restaurant> build(
    String restaurantId,
  );
}

/// See also [RestaurantDetail].
@ProviderFor(RestaurantDetail)
const restaurantDetailProvider = RestaurantDetailFamily();

/// See also [RestaurantDetail].
class RestaurantDetailFamily extends Family<AsyncValue<Restaurant>> {
  /// See also [RestaurantDetail].
  const RestaurantDetailFamily();

  /// See also [RestaurantDetail].
  RestaurantDetailProvider call(
    String restaurantId,
  ) {
    return RestaurantDetailProvider(
      restaurantId,
    );
  }

  @override
  RestaurantDetailProvider getProviderOverride(
    covariant RestaurantDetailProvider provider,
  ) {
    return call(
      provider.restaurantId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'restaurantDetailProvider';
}

/// See also [RestaurantDetail].
class RestaurantDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RestaurantDetail, Restaurant> {
  /// See also [RestaurantDetail].
  RestaurantDetailProvider(
    String restaurantId,
  ) : this._internal(
          () => RestaurantDetail()..restaurantId = restaurantId,
          from: restaurantDetailProvider,
          name: r'restaurantDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restaurantDetailHash,
          dependencies: RestaurantDetailFamily._dependencies,
          allTransitiveDependencies:
              RestaurantDetailFamily._allTransitiveDependencies,
          restaurantId: restaurantId,
        );

  RestaurantDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.restaurantId,
  }) : super.internal();

  final String restaurantId;

  @override
  FutureOr<Restaurant> runNotifierBuild(
    covariant RestaurantDetail notifier,
  ) {
    return notifier.build(
      restaurantId,
    );
  }

  @override
  Override overrideWith(RestaurantDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: RestaurantDetailProvider._internal(
        () => create()..restaurantId = restaurantId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        restaurantId: restaurantId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RestaurantDetail, Restaurant>
      createElement() {
    return _RestaurantDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantDetailProvider &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, restaurantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestaurantDetailRef on AutoDisposeAsyncNotifierProviderRef<Restaurant> {
  /// The parameter `restaurantId` of this provider.
  String get restaurantId;
}

class _RestaurantDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RestaurantDetail,
        Restaurant> with RestaurantDetailRef {
  _RestaurantDetailProviderElement(super.provider);

  @override
  String get restaurantId => (origin as RestaurantDetailProvider).restaurantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
