import 'package:dio/dio.dart';
import '../models/health_response_model.dart';
import '../models/login_response_model.dart';
import '../models/user_response_model.dart';

/// Talks to the raw HTTP endpoints and returns wire-format models.
/// Throws [DioException] on failure — mapping to [Failure] is the
/// repository's job, not this layer's.
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({required String email, required String password});

  Future<LoginResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  Future<UserResponseModel> getMyProfile();

  Future<UserResponseModel> updateMyProfile({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
  });

  Future<HealthResponseModel> getMyHealth();

  Future<LoginResponseModel> googleLogin({required String idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> googleLogin({required String idToken}) async {
    final response = await _dio.post('/api/auth/google', data: {
      'idToken': idToken,
    });
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<LoginResponseModel> login({required String email, required String password}) async {
    final response = await _dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<LoginResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    final response = await _dio.post('/api/auth/register', data: {
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
    });
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserResponseModel> getMyProfile() async {
    final response = await _dio.get('/api/users/me');
    return UserResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserResponseModel> updateMyProfile({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
  }) async {
    final response = await _dio.put('/api/users/me', data: {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'activityLevel': activityLevel,
    });
    return UserResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<HealthResponseModel> getMyHealth() async {
    final response = await _dio.get('/api/users/me/health');
    return HealthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
