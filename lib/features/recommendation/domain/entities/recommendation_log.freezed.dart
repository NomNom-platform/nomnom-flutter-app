// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationLog {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get mealType => throw _privateConstructorUsedError;
  List<String> get recommendedItemIds => throw _privateConstructorUsedError;
  String? get aiExplanation => throw _privateConstructorUsedError;
  bool get usedAi => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationLogCopyWith<RecommendationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationLogCopyWith<$Res> {
  factory $RecommendationLogCopyWith(
          RecommendationLog value, $Res Function(RecommendationLog) then) =
      _$RecommendationLogCopyWithImpl<$Res, RecommendationLog>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String mealType,
      List<String> recommendedItemIds,
      String? aiExplanation,
      bool usedAi,
      DateTime createdAt});
}

/// @nodoc
class _$RecommendationLogCopyWithImpl<$Res, $Val extends RecommendationLog>
    implements $RecommendationLogCopyWith<$Res> {
  _$RecommendationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? mealType = null,
    Object? recommendedItemIds = null,
    Object? aiExplanation = freezed,
    Object? usedAi = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedItemIds: null == recommendedItemIds
          ? _value.recommendedItemIds
          : recommendedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiExplanation: freezed == aiExplanation
          ? _value.aiExplanation
          : aiExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAi: null == usedAi
          ? _value.usedAi
          : usedAi // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationLogImplCopyWith<$Res>
    implements $RecommendationLogCopyWith<$Res> {
  factory _$$RecommendationLogImplCopyWith(_$RecommendationLogImpl value,
          $Res Function(_$RecommendationLogImpl) then) =
      __$$RecommendationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String mealType,
      List<String> recommendedItemIds,
      String? aiExplanation,
      bool usedAi,
      DateTime createdAt});
}

/// @nodoc
class __$$RecommendationLogImplCopyWithImpl<$Res>
    extends _$RecommendationLogCopyWithImpl<$Res, _$RecommendationLogImpl>
    implements _$$RecommendationLogImplCopyWith<$Res> {
  __$$RecommendationLogImplCopyWithImpl(_$RecommendationLogImpl _value,
      $Res Function(_$RecommendationLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? mealType = null,
    Object? recommendedItemIds = null,
    Object? aiExplanation = freezed,
    Object? usedAi = null,
    Object? createdAt = null,
  }) {
    return _then(_$RecommendationLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedItemIds: null == recommendedItemIds
          ? _value._recommendedItemIds
          : recommendedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aiExplanation: freezed == aiExplanation
          ? _value.aiExplanation
          : aiExplanation // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAi: null == usedAi
          ? _value.usedAi
          : usedAi // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$RecommendationLogImpl implements _RecommendationLog {
  const _$RecommendationLogImpl(
      {required this.id,
      required this.restaurantId,
      required this.mealType,
      required final List<String> recommendedItemIds,
      this.aiExplanation,
      required this.usedAi,
      required this.createdAt})
      : _recommendedItemIds = recommendedItemIds;

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String mealType;
  final List<String> _recommendedItemIds;
  @override
  List<String> get recommendedItemIds {
    if (_recommendedItemIds is EqualUnmodifiableListView)
      return _recommendedItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedItemIds);
  }

  @override
  final String? aiExplanation;
  @override
  final bool usedAi;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecommendationLog(id: $id, restaurantId: $restaurantId, mealType: $mealType, recommendedItemIds: $recommendedItemIds, aiExplanation: $aiExplanation, usedAi: $usedAi, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality()
                .equals(other._recommendedItemIds, _recommendedItemIds) &&
            (identical(other.aiExplanation, aiExplanation) ||
                other.aiExplanation == aiExplanation) &&
            (identical(other.usedAi, usedAi) || other.usedAi == usedAi) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      restaurantId,
      mealType,
      const DeepCollectionEquality().hash(_recommendedItemIds),
      aiExplanation,
      usedAi,
      createdAt);

  /// Create a copy of RecommendationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationLogImplCopyWith<_$RecommendationLogImpl> get copyWith =>
      __$$RecommendationLogImplCopyWithImpl<_$RecommendationLogImpl>(
          this, _$identity);
}

abstract class _RecommendationLog implements RecommendationLog {
  const factory _RecommendationLog(
      {required final String id,
      required final String restaurantId,
      required final String mealType,
      required final List<String> recommendedItemIds,
      final String? aiExplanation,
      required final bool usedAi,
      required final DateTime createdAt}) = _$RecommendationLogImpl;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String get mealType;
  @override
  List<String> get recommendedItemIds;
  @override
  String? get aiExplanation;
  @override
  bool get usedAi;
  @override
  DateTime get createdAt;

  /// Create a copy of RecommendationLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationLogImplCopyWith<_$RecommendationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
