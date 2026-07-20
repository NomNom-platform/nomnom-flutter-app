// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommended_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendedItemModel _$RecommendedItemModelFromJson(Map<String, dynamic> json) {
  return _RecommendedItemModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendedItemModel {
  String get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  double? get proteinG => throw _privateConstructorUsedError;
  double? get carbG => throw _privateConstructorUsedError;
  double? get fatG => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this RecommendedItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedItemModelCopyWith<RecommendedItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedItemModelCopyWith<$Res> {
  factory $RecommendedItemModelCopyWith(RecommendedItemModel value,
          $Res Function(RecommendedItemModel) then) =
      _$RecommendedItemModelCopyWithImpl<$Res, RecommendedItemModel>;
  @useResult
  $Res call(
      {String itemId,
      String name,
      int? calories,
      double? proteinG,
      double? carbG,
      double? fatG,
      double price,
      String reason});
}

/// @nodoc
class _$RecommendedItemModelCopyWithImpl<$Res,
        $Val extends RecommendedItemModel>
    implements $RecommendedItemModelCopyWith<$Res> {
  _$RecommendedItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? calories = freezed,
    Object? proteinG = freezed,
    Object? carbG = freezed,
    Object? fatG = freezed,
    Object? price = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinG: freezed == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double?,
      carbG: freezed == carbG
          ? _value.carbG
          : carbG // ignore: cast_nullable_to_non_nullable
              as double?,
      fatG: freezed == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendedItemModelImplCopyWith<$Res>
    implements $RecommendedItemModelCopyWith<$Res> {
  factory _$$RecommendedItemModelImplCopyWith(_$RecommendedItemModelImpl value,
          $Res Function(_$RecommendedItemModelImpl) then) =
      __$$RecommendedItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String name,
      int? calories,
      double? proteinG,
      double? carbG,
      double? fatG,
      double price,
      String reason});
}

/// @nodoc
class __$$RecommendedItemModelImplCopyWithImpl<$Res>
    extends _$RecommendedItemModelCopyWithImpl<$Res, _$RecommendedItemModelImpl>
    implements _$$RecommendedItemModelImplCopyWith<$Res> {
  __$$RecommendedItemModelImplCopyWithImpl(_$RecommendedItemModelImpl _value,
      $Res Function(_$RecommendedItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendedItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? calories = freezed,
    Object? proteinG = freezed,
    Object? carbG = freezed,
    Object? fatG = freezed,
    Object? price = null,
    Object? reason = null,
  }) {
    return _then(_$RecommendedItemModelImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinG: freezed == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double?,
      carbG: freezed == carbG
          ? _value.carbG
          : carbG // ignore: cast_nullable_to_non_nullable
              as double?,
      fatG: freezed == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedItemModelImpl extends _RecommendedItemModel {
  const _$RecommendedItemModelImpl(
      {required this.itemId,
      required this.name,
      this.calories,
      this.proteinG,
      this.carbG,
      this.fatG,
      required this.price,
      required this.reason})
      : super._();

  factory _$RecommendedItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedItemModelImplFromJson(json);

  @override
  final String itemId;
  @override
  final String name;
  @override
  final int? calories;
  @override
  final double? proteinG;
  @override
  final double? carbG;
  @override
  final double? fatG;
  @override
  final double price;
  @override
  final String reason;

  @override
  String toString() {
    return 'RecommendedItemModel(itemId: $itemId, name: $name, calories: $calories, proteinG: $proteinG, carbG: $carbG, fatG: $fatG, price: $price, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedItemModelImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbG, carbG) || other.carbG == carbG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemId, name, calories, proteinG,
      carbG, fatG, price, reason);

  /// Create a copy of RecommendedItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedItemModelImplCopyWith<_$RecommendedItemModelImpl>
      get copyWith =>
          __$$RecommendedItemModelImplCopyWithImpl<_$RecommendedItemModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedItemModelImplToJson(
      this,
    );
  }
}

abstract class _RecommendedItemModel extends RecommendedItemModel {
  const factory _RecommendedItemModel(
      {required final String itemId,
      required final String name,
      final int? calories,
      final double? proteinG,
      final double? carbG,
      final double? fatG,
      required final double price,
      required final String reason}) = _$RecommendedItemModelImpl;
  const _RecommendedItemModel._() : super._();

  factory _RecommendedItemModel.fromJson(Map<String, dynamic> json) =
      _$RecommendedItemModelImpl.fromJson;

  @override
  String get itemId;
  @override
  String get name;
  @override
  int? get calories;
  @override
  double? get proteinG;
  @override
  double? get carbG;
  @override
  double? get fatG;
  @override
  double get price;
  @override
  String get reason;

  /// Create a copy of RecommendedItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedItemModelImplCopyWith<_$RecommendedItemModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
