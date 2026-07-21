import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../entities/health_metrics.dart';
import '../entities/health_profile_input.dart';
import '../entities/user_profile.dart';
import '../entities/user_role.dart';

/// Contract the presentation layer depends on. The concrete implementation
/// (backed by Dio) lives in `data/repositories/auth_repository_impl.dart` —
/// tests can substitute a fake/mock implementing this interface instead.
abstract class AuthRepository {
  Future<Result<AuthSession>> login({required String email, required String password});

  Future<Result<AuthSession>> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  });

  Future<Result<UserProfile>> getMyProfile();

  Future<Result<UserProfile>> updateMyProfile(HealthProfileInput input);

  Future<Result<HealthMetrics>> getMyHealth();

  Future<Result<AuthSession>> googleLogin({required String idToken});

  Future<void> logout();
}
