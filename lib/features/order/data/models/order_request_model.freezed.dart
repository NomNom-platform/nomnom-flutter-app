// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) {
  return _OrderRequestModel.fromJson(json);
}

/// @nodoc
mixin _$OrderRequestModel {
  String get restaurantId => throw _privateConstructorUsedError;
  String get deliveryAddress => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this OrderRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderRequestModelCopyWith<OrderRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderRequestModelCopyWith<$Res> {
  factory $OrderRequestModelCopyWith(
          OrderRequestModel value, $Res Function(OrderRequestModel) then) =
      _$OrderRequestModelCopyWithImpl<$Res, OrderRequestModel>;
  @useResult
  $Res call(
      {String restaurantId,
      String deliveryAddress,
      String paymentMethod,
      String? note,
      List<OrderItemModel> items});
}

/// @nodoc
class _$OrderRequestModelCopyWithImpl<$Res, $Val extends OrderRequestModel>
    implements $OrderRequestModelCopyWith<$Res> {
  _$OrderRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? restaurantId = null,
    Object? deliveryAddress = null,
    Object? paymentMethod = null,
    Object? note = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderRequestModelImplCopyWith<$Res>
    implements $OrderRequestModelCopyWith<$Res> {
  factory _$$OrderRequestModelImplCopyWith(_$OrderRequestModelImpl value,
          $Res Function(_$OrderRequestModelImpl) then) =
      __$$OrderRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String restaurantId,
      String deliveryAddress,
      String paymentMethod,
      String? note,
      List<OrderItemModel> items});
}

/// @nodoc
class __$$OrderRequestModelImplCopyWithImpl<$Res>
    extends _$OrderRequestModelCopyWithImpl<$Res, _$OrderRequestModelImpl>
    implements _$$OrderRequestModelImplCopyWith<$Res> {
  __$$OrderRequestModelImplCopyWithImpl(_$OrderRequestModelImpl _value,
      $Res Function(_$OrderRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? restaurantId = null,
    Object? deliveryAddress = null,
    Object? paymentMethod = null,
    Object? note = freezed,
    Object? items = null,
  }) {
    return _then(_$OrderRequestModelImpl(
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderRequestModelImpl implements _OrderRequestModel {
  const _$OrderRequestModelImpl(
      {required this.restaurantId,
      required this.deliveryAddress,
      required this.paymentMethod,
      this.note,
      final List<OrderItemModel> items = const []})
      : _items = items;

  factory _$OrderRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderRequestModelImplFromJson(json);

  @override
  final String restaurantId;
  @override
  final String deliveryAddress;
  @override
  final String paymentMethod;
  @override
  final String? note;
  final List<OrderItemModel> _items;
  @override
  @JsonKey()
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'OrderRequestModel(restaurantId: $restaurantId, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, note: $note, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderRequestModelImpl &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, restaurantId, deliveryAddress,
      paymentMethod, note, const DeepCollectionEquality().hash(_items));

  /// Create a copy of OrderRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderRequestModelImplCopyWith<_$OrderRequestModelImpl> get copyWith =>
      __$$OrderRequestModelImplCopyWithImpl<_$OrderRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderRequestModelImplToJson(
      this,
    );
  }
}

abstract class _OrderRequestModel implements OrderRequestModel {
  const factory _OrderRequestModel(
      {required final String restaurantId,
      required final String deliveryAddress,
      required final String paymentMethod,
      final String? note,
      final List<OrderItemModel> items}) = _$OrderRequestModelImpl;

  factory _OrderRequestModel.fromJson(Map<String, dynamic> json) =
      _$OrderRequestModelImpl.fromJson;

  @override
  String get restaurantId;
  @override
  String get deliveryAddress;
  @override
  String get paymentMethod;
  @override
  String? get note;
  @override
  List<OrderItemModel> get items;

  /// Create a copy of OrderRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderRequestModelImplCopyWith<_$OrderRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
