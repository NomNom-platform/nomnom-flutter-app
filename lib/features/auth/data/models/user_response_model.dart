import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_role.dart';

part 'user_response_model.freezed.dart';
part 'user_response_model.g.dart';

/// Mirrors `UserResponse` from `UserController.java`.
@freezed
class UserResponseModel with _$UserResponseModel {
  const UserResponseModel._();

  const factory UserResponseModel({
    required String id,
    required String email,
    required String fullName,
    required String role,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? activityLevel,
  }) = _UserResponseModel;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => _$UserResponseModelFromJson(json);

  UserProfile toEntity() => UserProfile(
        id: id,
        email: email,
        fullName: fullName,
        role: UserRole.fromApiValue(role),
        height: height,
        weight: weight,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
      );
}
