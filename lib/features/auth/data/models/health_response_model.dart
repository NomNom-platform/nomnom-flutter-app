import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/health_metrics.dart';

part 'health_response_model.freezed.dart';
part 'health_response_model.g.dart';

/// Mirrors `HealthResponse` from `UserController.java`.
@freezed
class HealthResponseModel with _$HealthResponseModel {
  const HealthResponseModel._();

  const factory HealthResponseModel({
    required double bmi,
    required String bmiCategory,
    required double tdee,
    required double calorieGoal,
  }) = _HealthResponseModel;

  factory HealthResponseModel.fromJson(Map<String, dynamic> json) => _$HealthResponseModelFromJson(json);

  HealthMetrics toEntity() => HealthMetrics(
        bmi: bmi,
        bmiCategory: bmiCategory,
        tdee: tdee,
        calorieGoal: calorieGoal,
      );
}
