// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationState {
  bool get isLoading => throw _privateConstructorUsedError;
  Failure? get failure => throw _privateConstructorUsedError;
  RecommendationResult? get result => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationStateCopyWith<RecommendationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationStateCopyWith<$Res> {
  factory $RecommendationStateCopyWith(
          RecommendationState value, $Res Function(RecommendationState) then) =
      _$RecommendationStateCopyWithImpl<$Res, RecommendationState>;
  @useResult
  $Res call({bool isLoading, Failure? failure, RecommendationResult? result});

  $RecommendationResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$RecommendationStateCopyWithImpl<$Res, $Val extends RecommendationState>
    implements $RecommendationStateCopyWith<$Res> {
  _$RecommendationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? failure = freezed,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as RecommendationResult?,
    ) as $Val);
  }

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $RecommendationResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationStateImplCopyWith<$Res>
    implements $RecommendationStateCopyWith<$Res> {
  factory _$$RecommendationStateImplCopyWith(_$RecommendationStateImpl value,
          $Res Function(_$RecommendationStateImpl) then) =
      __$$RecommendationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, Failure? failure, RecommendationResult? result});

  @override
  $RecommendationResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$RecommendationStateImplCopyWithImpl<$Res>
    extends _$RecommendationStateCopyWithImpl<$Res, _$RecommendationStateImpl>
    implements _$$RecommendationStateImplCopyWith<$Res> {
  __$$RecommendationStateImplCopyWithImpl(_$RecommendationStateImpl _value,
      $Res Function(_$RecommendationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? failure = freezed,
    Object? result = freezed,
  }) {
    return _then(_$RecommendationStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as RecommendationResult?,
    ));
  }
}

/// @nodoc

class _$RecommendationStateImpl implements _RecommendationState {
  const _$RecommendationStateImpl(
      {this.isLoading = false, this.failure, this.result});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Failure? failure;
  @override
  final RecommendationResult? result;

  @override
  String toString() {
    return 'RecommendationState(isLoading: $isLoading, failure: $failure, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, failure, result);

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationStateImplCopyWith<_$RecommendationStateImpl> get copyWith =>
      __$$RecommendationStateImplCopyWithImpl<_$RecommendationStateImpl>(
          this, _$identity);
}

abstract class _RecommendationState implements RecommendationState {
  const factory _RecommendationState(
      {final bool isLoading,
      final Failure? failure,
      final RecommendationResult? result}) = _$RecommendationStateImpl;

  @override
  bool get isLoading;
  @override
  Failure? get failure;
  @override
  RecommendationResult? get result;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationStateImplCopyWith<_$RecommendationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
