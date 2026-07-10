// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HealthMetrics {
  double get bmi => throw _privateConstructorUsedError;
  String get bmiCategory => throw _privateConstructorUsedError;
  double get tdee => throw _privateConstructorUsedError;
  double get calorieGoal => throw _privateConstructorUsedError;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthMetricsCopyWith<HealthMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthMetricsCopyWith<$Res> {
  factory $HealthMetricsCopyWith(
          HealthMetrics value, $Res Function(HealthMetrics) then) =
      _$HealthMetricsCopyWithImpl<$Res, HealthMetrics>;
  @useResult
  $Res call({double bmi, String bmiCategory, double tdee, double calorieGoal});
}

/// @nodoc
class _$HealthMetricsCopyWithImpl<$Res, $Val extends HealthMetrics>
    implements $HealthMetricsCopyWith<$Res> {
  _$HealthMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bmi = null,
    Object? bmiCategory = null,
    Object? tdee = null,
    Object? calorieGoal = null,
  }) {
    return _then(_value.copyWith(
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      bmiCategory: null == bmiCategory
          ? _value.bmiCategory
          : bmiCategory // ignore: cast_nullable_to_non_nullable
              as String,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double,
      calorieGoal: null == calorieGoal
          ? _value.calorieGoal
          : calorieGoal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthMetricsImplCopyWith<$Res>
    implements $HealthMetricsCopyWith<$Res> {
  factory _$$HealthMetricsImplCopyWith(
          _$HealthMetricsImpl value, $Res Function(_$HealthMetricsImpl) then) =
      __$$HealthMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double bmi, String bmiCategory, double tdee, double calorieGoal});
}

/// @nodoc
class __$$HealthMetricsImplCopyWithImpl<$Res>
    extends _$HealthMetricsCopyWithImpl<$Res, _$HealthMetricsImpl>
    implements _$$HealthMetricsImplCopyWith<$Res> {
  __$$HealthMetricsImplCopyWithImpl(
      _$HealthMetricsImpl _value, $Res Function(_$HealthMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bmi = null,
    Object? bmiCategory = null,
    Object? tdee = null,
    Object? calorieGoal = null,
  }) {
    return _then(_$HealthMetricsImpl(
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      bmiCategory: null == bmiCategory
          ? _value.bmiCategory
          : bmiCategory // ignore: cast_nullable_to_non_nullable
              as String,
      tdee: null == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double,
      calorieGoal: null == calorieGoal
          ? _value.calorieGoal
          : calorieGoal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$HealthMetricsImpl implements _HealthMetrics {
  const _$HealthMetricsImpl(
      {required this.bmi,
      required this.bmiCategory,
      required this.tdee,
      required this.calorieGoal});

  @override
  final double bmi;
  @override
  final String bmiCategory;
  @override
  final double tdee;
  @override
  final double calorieGoal;

  @override
  String toString() {
    return 'HealthMetrics(bmi: $bmi, bmiCategory: $bmiCategory, tdee: $tdee, calorieGoal: $calorieGoal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthMetricsImpl &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.bmiCategory, bmiCategory) ||
                other.bmiCategory == bmiCategory) &&
            (identical(other.tdee, tdee) || other.tdee == tdee) &&
            (identical(other.calorieGoal, calorieGoal) ||
                other.calorieGoal == calorieGoal));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, bmi, bmiCategory, tdee, calorieGoal);

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      __$$HealthMetricsImplCopyWithImpl<_$HealthMetricsImpl>(this, _$identity);
}

abstract class _HealthMetrics implements HealthMetrics {
  const factory _HealthMetrics(
      {required final double bmi,
      required final String bmiCategory,
      required final double tdee,
      required final double calorieGoal}) = _$HealthMetricsImpl;

  @override
  double get bmi;
  @override
  String get bmiCategory;
  @override
  double get tdee;
  @override
  double get calorieGoal;

  /// Create a copy of HealthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthMetricsImplCopyWith<_$HealthMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
