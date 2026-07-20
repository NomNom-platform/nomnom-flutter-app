// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationResponseModel _$RecommendationResponseModelFromJson(
    Map<String, dynamic> json) {
  return _RecommendationResponseModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationResponseModel {
  List<RecommendedItemModel> get items => throw _privateConstructorUsedError;
  String? get aiExplanation => throw _privateConstructorUsedError;
  bool get usedAi => throw _privateConstructorUsedError;

  /// Serializes this RecommendationResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationResponseModelCopyWith<RecommendationResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationResponseModelCopyWith<$Res> {
  factory $RecommendationResponseModelCopyWith(
          RecommendationResponseModel value,
          $Res Function(RecommendationResponseModel) then) =
      _$RecommendationResponseModelCopyWithImpl<$Res,
          RecommendationResponseModel>;
  @useResult
  $Res call(
      {List<RecommendedItemModel> items, String? aiExplanation, bool usedAi});
}

/// @nodoc
class _$RecommendationResponseModelCopyWithImpl<$Res,
        $Val extends RecommendationResponseModel>
    implements $RecommendationResponseModelCopyWith<$Res> {
  _$RecommendationResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationResponseModel
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
              as List<RecommendedItemModel>,
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
abstract class _$$RecommendationResponseModelImplCopyWith<$Res>
    implements $RecommendationResponseModelCopyWith<$Res> {
  factory _$$RecommendationResponseModelImplCopyWith(
          _$RecommendationResponseModelImpl value,
          $Res Function(_$RecommendationResponseModelImpl) then) =
      __$$RecommendationResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecommendedItemModel> items, String? aiExplanation, bool usedAi});
}

/// @nodoc
class __$$RecommendationResponseModelImplCopyWithImpl<$Res>
    extends _$RecommendationResponseModelCopyWithImpl<$Res,
        _$RecommendationResponseModelImpl>
    implements _$$RecommendationResponseModelImplCopyWith<$Res> {
  __$$RecommendationResponseModelImplCopyWithImpl(
      _$RecommendationResponseModelImpl _value,
      $Res Function(_$RecommendationResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? aiExplanation = freezed,
    Object? usedAi = null,
  }) {
    return _then(_$RecommendationResponseModelImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItemModel>,
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
@JsonSerializable()
class _$RecommendationResponseModelImpl extends _RecommendationResponseModel {
  const _$RecommendationResponseModelImpl(
      {required final List<RecommendedItemModel> items,
      this.aiExplanation,
      required this.usedAi})
      : _items = items,
        super._();

  factory _$RecommendationResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RecommendationResponseModelImplFromJson(json);

  final List<RecommendedItemModel> _items;
  @override
  List<RecommendedItemModel> get items {
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
    return 'RecommendationResponseModel(items: $items, aiExplanation: $aiExplanation, usedAi: $usedAi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationResponseModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.aiExplanation, aiExplanation) ||
                other.aiExplanation == aiExplanation) &&
            (identical(other.usedAi, usedAi) || other.usedAi == usedAi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), aiExplanation, usedAi);

  /// Create a copy of RecommendationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationResponseModelImplCopyWith<_$RecommendationResponseModelImpl>
      get copyWith => __$$RecommendationResponseModelImplCopyWithImpl<
          _$RecommendationResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationResponseModelImplToJson(
      this,
    );
  }
}

abstract class _RecommendationResponseModel
    extends RecommendationResponseModel {
  const factory _RecommendationResponseModel(
      {required final List<RecommendedItemModel> items,
      final String? aiExplanation,
      required final bool usedAi}) = _$RecommendationResponseModelImpl;
  const _RecommendationResponseModel._() : super._();

  factory _RecommendationResponseModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationResponseModelImpl.fromJson;

  @override
  List<RecommendedItemModel> get items;
  @override
  String? get aiExplanation;
  @override
  bool get usedAi;

  /// Create a copy of RecommendationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationResponseModelImplCopyWith<_$RecommendationResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
