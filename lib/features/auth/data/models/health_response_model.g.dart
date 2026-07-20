// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthResponseModelImpl _$$HealthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthResponseModelImpl(
      bmi: (json['bmi'] as num).toDouble(),
      bmiCategory: json['bmiCategory'] as String,
      tdee: (json['tdee'] as num).toDouble(),
      calorieGoal: (json['calorieGoal'] as num).toDouble(),
    );

Map<String, dynamic> _$$HealthResponseModelImplToJson(
        _$HealthResponseModelImpl instance) =>
    <String, dynamic>{
      'bmi': instance.bmi,
      'bmiCategory': instance.bmiCategory,
      'tdee': instance.tdee,
      'calorieGoal': instance.calorieGoal,
    };
