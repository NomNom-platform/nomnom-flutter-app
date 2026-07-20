// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationResult {
  List<RecommendedItem> get items => throw _privateConstructorUsedError;
  String? get aiExplanation => throw _privateConstructorUsedError;
  bool get usedAi => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationResultCopyWith<RecommendationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationResultCopyWith<$Res> {
  factory $RecommendationResultCopyWith(RecommendationResult value,
          $Res Function(RecommendationResult) then) =
      _$RecommendationResultCopyWithImpl<$Res, RecommendationResult>;
  @useResult
  $Res call({List<RecommendedItem> items, String? aiExplanation, bool usedAi});
}

/// @nodoc
class _$RecommendationResultCopyWithImpl<$Res,
        $Val extends RecommendationResult>
    implements $RecommendationResultCopyWith<$Res> {
  _$RecommendationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? aiExplanation = freezed,
    Object? usedAi = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      aiExplanation: freezed == aiExplanation
          ? _value.aiExplanation
          : aiExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAi: null == usedAi
          ? _value.usedAi
          : usedAi // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationResultImplCopyWith<$Res>
    implements $RecommendationResultCopyWith<$Res> {
  factory _$$RecommendationResultImplCopyWith(_$RecommendationResultImpl value,
          $Res Function(_$RecommendationResultImpl) then) =
      __$$RecommendationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RecommendedItem> items, String? aiExplanation, bool usedAi});
}

/// @nodoc
class __$$RecommendationResultImplCopyWithImpl<$Res>
    extends _$RecommendationResultCopyWithImpl<$Res, _$RecommendationResultImpl>
    implements _$$RecommendationResultImplCopyWith<$Res> {
  __$$RecommendationResultImplCopyWithImpl(_$RecommendationResultImpl _value,
      $Res Function(_$RecommendationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? aiExplanation = freezed,
    Object? usedAi = null,
  }) {
    return _then(_$RecommendationResultImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      aiExplanation: freezed == aiExplanation
          ? _value.aiExplanation
          : aiExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAi: null == usedAi
          ? _value.usedAi
          : usedAi // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RecommendationResultImpl implements _RecommendationResult {
  const _$RecommendationResultImpl(
      {required final List<RecommendedItem> items,
      this.aiExplanation,
      required this.usedAi})
      : _items = items;

  final List<RecommendedItem> _items;
  @override
  List<RecommendedItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? aiExplanation;
  @override
  final bool usedAi;

  @override
  String toString() {
    return 'RecommendationResult(items: $items, aiExplanation: $aiExplanation, usedAi: $usedAi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationResultImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.aiExplanation, aiExplanation) ||
                other.aiExplanation == aiExplanation) &&
            (identical(other.usedAi, usedAi) || other.usedAi == usedAi));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), aiExplanation, usedAi);

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationResultImplCopyWith<_$RecommendationResultImpl>
      get copyWith =>
          __$$RecommendationResultImplCopyWithImpl<_$RecommendationResultImpl>(
              this, _$identity);
}

abstract class _RecommendationResult implements RecommendationResult {
  const factory _RecommendationResult(
      {required final List<RecommendedItem> items,
      final String? aiExplanation,
      required final bool usedAi}) = _$RecommendationResultImpl;

  @override
  List<RecommendedItem> get items;
  @override
  String? get aiExplanation;
  @override
  bool get usedAi;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationResultImplCopyWith<_$RecommendationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
