import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_metrics.freezed.dart';

@freezed
class HealthMetrics with _$HealthMetrics {
  const factory HealthMetrics({
    required double bmi,
    required String bmiCategory,
    required double tdee,
    required double calorieGoal,
  }) = _HealthMetrics;
}
