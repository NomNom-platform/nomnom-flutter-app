import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_role.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Mirrors `LoginResponse` from `AuthController.java` verbatim — the DTO
/// shape follows the wire format, entity conversion is explicit via
/// [toEntity] rather than baked into JSON parsing.
@freezed
class LoginResponseModel with _$LoginResponseModel {
  const LoginResponseModel._();

  const factory LoginResponseModel({
    required String token,
    required String userId,
    required String email,
    required String role,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  AuthSession toEntity() => AuthSession(
        token: token,
        userId: userId,
        email: email,
        role: UserRole.fromApiValue(role),
      );
}
