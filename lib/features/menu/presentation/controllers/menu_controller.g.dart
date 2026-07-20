// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$menuControllerHash() => r'69748be02f81748b29f48717818ad803a27dc97c';

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

abstract class _$MenuController
    extends BuildlessAutoDisposeAsyncNotifier<List<MenuItem>> {
  late final String restaurantId;

  FutureOr<List<MenuItem>> build(
    String restaurantId,
  );
}

/// Loads and mutates the menu items for a single restaurant. Keyed by
/// [restaurantId] so each restaurant has its own cached list.
///
/// Copied from [MenuController].
@ProviderFor(MenuController)
const menuControllerProvider = MenuControllerFamily();

/// Loads and mutates the menu items for a single restaurant. Keyed by
/// [restaurantId] so each restaurant has its own cached list.
///
/// Copied from [MenuController].
class MenuControllerFamily extends Family<AsyncValue<List<MenuItem>>> {
  /// Loads and mutates the menu items for a single restaurant. Keyed by
  /// [restaurantId] so each restaurant has its own cached list.
  ///
  /// Copied from [MenuController].
  const MenuControllerFamily();

  /// Loads and mutates the menu items for a single restaurant. Keyed by
  /// [restaurantId] so each restaurant has its own cached list.
  ///
  /// Copied from [MenuController].
  MenuControllerProvider call(
    String restaurantId,
  ) {
    return MenuControllerProvider(
      restaurantId,
    );
  }

  @override
  MenuControllerProvider getProviderOverride(
    covariant MenuControllerProvider provider,
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
  String? get name => r'menuControllerProvider';
}

/// Loads and mutates the menu items for a single restaurant. Keyed by
/// [restaurantId] so each restaurant has its own cached list.
///
/// Copied from [MenuController].
class MenuControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MenuController, List<MenuItem>> {
  /// Loads and mutates the menu items for a single restaurant. Keyed by
  /// [restaurantId] so each restaurant has its own cached list.
  ///
  /// Copied from [MenuController].
  MenuControllerProvider(
    String restaurantId,
  ) : this._internal(
          () => MenuController()..restaurantId = restaurantId,
          from: menuControllerProvider,
          name: r'menuControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuControllerHash,
          dependencies: MenuControllerFamily._dependencies,
          allTransitiveDependencies:
              MenuControllerFamily._allTransitiveDependencies,
          restaurantId: restaurantId,
        );

  MenuControllerProvider._internal(
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
  FutureOr<List<MenuItem>> runNotifierBuild(
    covariant MenuController notifier,
  ) {
    return notifier.build(
      restaurantId,
    );
  }

  @override
  Override overrideWith(MenuController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MenuControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MenuController, List<MenuItem>>
      createElement() {
    return _MenuControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuControllerProvider &&
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
mixin MenuControllerRef on AutoDisposeAsyncNotifierProviderRef<List<MenuItem>> {
  /// The parameter `restaurantId` of this provider.
  String get restaurantId;
}

class _MenuControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MenuController,
        List<MenuItem>> with MenuControllerRef {
  _MenuControllerProviderElement(super.provider);

  @override
  String get restaurantId => (origin as MenuControllerProvider).restaurantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
