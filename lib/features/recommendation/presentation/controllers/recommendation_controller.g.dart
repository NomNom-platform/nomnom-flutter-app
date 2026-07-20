// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recommendationHistoryHash() =>
    r'291fdf4e83b53ccce598feb11553aa2c2e1d1a89';

/// See also [recommendationHistory].
@ProviderFor(recommendationHistory)
final recommendationHistoryProvider =
    AutoDisposeFutureProvider<RecommendationHistoryPage>.internal(
  recommendationHistory,
  name: r'recommendationHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecommendationHistoryRef
    = AutoDisposeFutureProviderRef<RecommendationHistoryPage>;
String _$recommendationControllerHash() =>
    r'c58a3d0be980b8d7804be795d2642909883e8d75';

/// See also [RecommendationController].
@ProviderFor(RecommendationController)
final recommendationControllerProvider = AutoDisposeNotifierProvider<
    RecommendationController, RecommendationState>.internal(
  RecommendationController.new,
  name: r'recommendationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecommendationController = AutoDisposeNotifier<RecommendationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
