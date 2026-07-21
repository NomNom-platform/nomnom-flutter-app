import 'package:dio/dio.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/health_metrics.dart';
import '../../domain/entities/health_profile_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  const AuthRepositoryImpl(this._remote, this._tokenStorage);

  @override
  Future<Result<AuthSession>> login({required String email, required String password}) async {
    try {
      final model = await _remote.login(email: email, password: password);
      final session = model.toEntity();
      await _persistSession(session);
      return Result.success(session);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<AuthSession>> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final model = await _remote.register(
        email: email,
        password: password,
        fullName: fullName,
        role: role.apiValue,
      );
      final session = model.toEntity();
      await _persistSession(session);
      return Result.success(session);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<UserProfile>> getMyProfile() async {
    try {
      final model = await _remote.getMyProfile();
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<UserProfile>> updateMyProfile(HealthProfileInput input) async {
    try {
      final model = await _remote.updateMyProfile(
        height: input.height,
        weight: input.weight,
        age: input.age,
        gender: input.gender,
        activityLevel: input.activityLevel,
      );
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<HealthMetrics>> getMyHealth() async {
    try {
      final model = await _remote.getMyHealth();
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<AuthSession>> googleLogin({required String idToken}) async {
    try {
      final model = await _remote.googleLogin(idToken: idToken);
      final session = model.toEntity();
      await _persistSession(session);
      return Result.success(session);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<void> logout() => _tokenStorage.clear();

  Future<void> _persistSession(AuthSession session) {
    return _tokenStorage.saveSession(
      token: session.token,
      userId: session.userId,
      email: session.email,
      role: session.role.apiValue,
    );
  }
}
