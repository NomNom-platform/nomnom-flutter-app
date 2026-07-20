// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderDetailsControllerHash() =>
    r'f3498e0b6565fd9c2a3b3cc7bb28b1cc0f99c5ae';

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

abstract class _$OrderDetailsController
    extends BuildlessAutoDisposeAsyncNotifier<OrderModel> {
  late final String orderId;

  FutureOr<OrderModel> build(
    String orderId,
  );
}

/// See also [OrderDetailsController].
@ProviderFor(OrderDetailsController)
const orderDetailsControllerProvider = OrderDetailsControllerFamily();

/// See also [OrderDetailsController].
class OrderDetailsControllerFamily extends Family<AsyncValue<OrderModel>> {
  /// See also [OrderDetailsController].
  const OrderDetailsControllerFamily();

  /// See also [OrderDetailsController].
  OrderDetailsControllerProvider call(
    String orderId,
  ) {
    return OrderDetailsControllerProvider(
      orderId,
    );
  }

  @override
  OrderDetailsControllerProvider getProviderOverride(
    covariant OrderDetailsControllerProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderDetailsControllerProvider';
}

/// See also [OrderDetailsController].
class OrderDetailsControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OrderDetailsController,
        OrderModel> {
  /// See also [OrderDetailsController].
  OrderDetailsControllerProvider(
    String orderId,
  ) : this._internal(
          () => OrderDetailsController()..orderId = orderId,
          from: orderDetailsControllerProvider,
          name: r'orderDetailsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderDetailsControllerHash,
          dependencies: OrderDetailsControllerFamily._dependencies,
          allTransitiveDependencies:
              OrderDetailsControllerFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderDetailsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  FutureOr<OrderModel> runNotifierBuild(
    covariant OrderDetailsController notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(OrderDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailsControllerProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OrderDetailsController, OrderModel>
      createElement() {
    return _OrderDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailsControllerProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<OrderModel> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OrderDetailsController,
        OrderModel> with OrderDetailsControllerRef {
  _OrderDetailsControllerProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailsControllerProvider).orderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
