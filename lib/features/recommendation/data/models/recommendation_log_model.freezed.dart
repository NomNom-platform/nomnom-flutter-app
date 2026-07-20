// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationLogModel _$RecommendationLogModelFromJson(
    Map<String, dynamic> json) {
  return _RecommendationLogModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationLogModel {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get mealType => throw _privateConstructorUsedError;
  List<String> get recommendedItemIds => throw _privateConstructorUsedError;
  String? get aiExplanation => throw _privateConstructorUsedError;
  bool get usedAi => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecommendationLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationLogModelCopyWith<RecommendationLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationLogModelCopyWith<$Res> {
  factory $RecommendationLogModelCopyWith(RecommendationLogModel value,
          $Res Function(RecommendationLogModel) then) =
      _$RecommendationLogModelCopyWithImpl<$Res, RecommendationLogModel>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String mealType,
      List<String> recommendedItemIds,
      String? aiExplanation,
      bool usedAi,
      String createdAt});
}

/// @nodoc
class _$RecommendationLogModelCopyWithImpl<$Res,
        $Val extends RecommendationLogModel>
    implements $RecommendationLogModelCopyWith<$Res> {
  _$RecommendationLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationLogModel
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
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationLogModelImplCopyWith<$Res>
    implements $RecommendationLogModelCopyWith<$Res> {
  factory _$$RecommendationLogModelImplCopyWith(
          _$RecommendationLogModelImpl value,
          $Res Function(_$RecommendationLogModelImpl) then) =
      __$$RecommendationLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String mealType,
      List<String> recommendedItemIds,
      String? aiExplanation,
      bool usedAi,
      String createdAt});
}

/// @nodoc
class __$$RecommendationLogModelImplCopyWithImpl<$Res>
    extends _$RecommendationLogModelCopyWithImpl<$Res,
        _$RecommendationLogModelImpl>
    implements _$$RecommendationLogModelImplCopyWith<$Res> {
  __$$RecommendationLogModelImplCopyWithImpl(
      _$RecommendationLogModelImpl _value,
      $Res Function(_$RecommendationLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationLogModel
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
    return _then(_$RecommendationLogModelImpl(
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
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationLogModelImpl extends _RecommendationLogModel {
  const _$RecommendationLogModelImpl(
      {required this.id,
      required this.restaurantId,
      required this.mealType,
      required final List<String> recommendedItemIds,
      this.aiExplanation,
      required this.usedAi,
      required this.createdAt})
      : _recommendedItemIds = recommendedItemIds,
        super._();

  factory _$RecommendationLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationLogModelImplFromJson(json);

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
  final String createdAt;

  @override
  String toString() {
    return 'RecommendationLogModel(id: $id, restaurantId: $restaurantId, mealType: $mealType, recommendedItemIds: $recommendedItemIds, aiExplanation: $aiExplanation, usedAi: $usedAi, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationLogModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of RecommendationLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationLogModelImplCopyWith<_$RecommendationLogModelImpl>
      get copyWith => __$$RecommendationLogModelImplCopyWithImpl<
          _$RecommendationLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationLogModelImplToJson(
      this,
    );
  }
}

abstract class _RecommendationLogModel extends RecommendationLogModel {
  const factory _RecommendationLogModel(
      {required final String id,
      required final String restaurantId,
      required final String mealType,
      required final List<String> recommendedItemIds,
      final String? aiExplanation,
      required final bool usedAi,
      required final String createdAt}) = _$RecommendationLogModelImpl;
  const _RecommendationLogModel._() : super._();

  factory _RecommendationLogModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationLogModelImpl.fromJson;

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
  String get createdAt;

  /// Create a copy of RecommendationLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationLogModelImplCopyWith<_$RecommendationLogModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
