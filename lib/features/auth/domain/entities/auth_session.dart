import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'auth_session.freezed.dart';

/// Pure domain representation of a successful login/register — carries only
/// what the app needs to act on, independent of the wire format.
@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    required String userId,
    required String email,
    required UserRole role,
  }) = _AuthSession;
}
