import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String fullName,
    required UserRole role,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? activityLevel,
  }) = _UserProfile;
}
