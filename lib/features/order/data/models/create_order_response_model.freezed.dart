// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateOrderResponseModel _$CreateOrderResponseModelFromJson(
    Map<String, dynamic> json) {
  return _CreateOrderResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderResponseModel {
  OrderModel get order => throw _privateConstructorUsedError;
  String? get paymentUrl => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderResponseModelCopyWith<CreateOrderResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderResponseModelCopyWith<$Res> {
  factory $CreateOrderResponseModelCopyWith(CreateOrderResponseModel value,
          $Res Function(CreateOrderResponseModel) then) =
      _$CreateOrderResponseModelCopyWithImpl<$Res, CreateOrderResponseModel>;
  @useResult
  $Res call({OrderModel order, String? paymentUrl});

  $OrderModelCopyWith<$Res> get order;
}

/// @nodoc
class _$CreateOrderResponseModelCopyWithImpl<$Res,
        $Val extends CreateOrderResponseModel>
    implements $CreateOrderResponseModelCopyWith<$Res> {
  _$CreateOrderResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? paymentUrl = freezed,
  }) {
    return _then(_value.copyWith(
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderModel,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res> get order {
    return $OrderModelCopyWith<$Res>(_value.order, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateOrderResponseModelImplCopyWith<$Res>
    implements $CreateOrderResponseModelCopyWith<$Res> {
  factory _$$CreateOrderResponseModelImplCopyWith(
          _$CreateOrderResponseModelImpl value,
          $Res Function(_$CreateOrderResponseModelImpl) then) =
      __$$CreateOrderResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrderModel order, String? paymentUrl});

  @override
  $OrderModelCopyWith<$Res> get order;
}

/// @nodoc
class __$$CreateOrderResponseModelImplCopyWithImpl<$Res>
    extends _$CreateOrderResponseModelCopyWithImpl<$Res,
        _$CreateOrderResponseModelImpl>
    implements _$$CreateOrderResponseModelImplCopyWith<$Res> {
  __$$CreateOrderResponseModelImplCopyWithImpl(
      _$CreateOrderResponseModelImpl _value,
      $Res Function(_$CreateOrderResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? paymentUrl = freezed,
  }) {
    return _then(_$CreateOrderResponseModelImpl(
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderModel,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderResponseModelImpl implements _CreateOrderResponseModel {
  const _$CreateOrderResponseModelImpl({required this.order, this.paymentUrl});

  factory _$CreateOrderResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderResponseModelImplFromJson(json);

  @override
  final OrderModel order;
  @override
  final String? paymentUrl;

  @override
  String toString() {
    return 'CreateOrderResponseModel(order: $order, paymentUrl: $paymentUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderResponseModelImpl &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, order, paymentUrl);

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderResponseModelImplCopyWith<_$CreateOrderResponseModelImpl>
      get copyWith => __$$CreateOrderResponseModelImplCopyWithImpl<
          _$CreateOrderResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderResponseModelImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderResponseModel implements CreateOrderResponseModel {
  const factory _CreateOrderResponseModel(
      {required final OrderModel order,
      final String? paymentUrl}) = _$CreateOrderResponseModelImpl;

  factory _CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =
      _$CreateOrderResponseModelImpl.fromJson;

  @override
  OrderModel get order;
  @override
  String? get paymentUrl;

  /// Create a copy of CreateOrderResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderResponseModelImplCopyWith<_$CreateOrderResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
