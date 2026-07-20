import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_role.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    Failure? failure,
    UserProfile? profile,
    UserRole? role,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}
