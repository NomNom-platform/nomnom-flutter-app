import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_profile_input.freezed.dart';

/// Parameter object for [UpdateHealthProfileUseCase] — keeps the use case
/// signature stable even if the backend adds more editable fields later.
@freezed
class HealthProfileInput with _$HealthProfileInput {
  const factory HealthProfileInput({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
  }) = _HealthProfileInput;
}
