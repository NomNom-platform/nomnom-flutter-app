// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authDioHash() => r'af3276159666265022bcc94c1947c3ded72a3e29';

/// Wiring only — no business logic. Kept separate from [AuthController] so
/// the DI graph can be swapped/mocked independently of the controller.
///
/// Copied from [authDio].
@ProviderFor(authDio)
final authDioProvider = Provider<Dio>.internal(
  authDio,
  name: r'authDioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authDioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthDioRef = ProviderRef<Dio>;
String _$authRemoteDataSourceHash() =>
    r'ec5cd8816bc28f2d3822696aca9b375552ad5cda';

/// See also [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = ProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'32ba87c45d69ec6d2b9091d0179dfcc7d707fa36';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
