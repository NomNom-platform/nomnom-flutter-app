import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/health_metrics.dart';
import '../../domain/entities/health_profile_input.dart';
import '../../domain/entities/user_role.dart';
import '../providers/auth_di.dart';
import '../state/auth_state.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() => const AuthState();

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(authRepositoryProvider).login(email: email, password: password);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (session) {
        state = state.copyWith(isLoading: false, isAuthenticated: true, role: session.role, failure: null);
        return true;
      },
    );
  }

  Future<bool> loginWithGoogle({required String idToken}) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(authRepositoryProvider).googleLogin(idToken: idToken);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (session) {
        state = state.copyWith(isLoading: false, isAuthenticated: true, role: session.role, failure: null);
        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(authRepositoryProvider).register(
          email: email,
          password: password,
          fullName: fullName,
          role: role,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (session) {
        state = state.copyWith(isLoading: false, isAuthenticated: true, role: session.role, failure: null);
        return true;
      },
    );
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(authRepositoryProvider).getMyProfile();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (profile) => state = state.copyWith(
        isLoading: false,
        profile: profile,
        role: profile.role,
        isAuthenticated: true,
        failure: null,
      ),
    );
  }

  Future<bool> updateHealthProfile(HealthProfileInput input) async {
    final validationError = _validateHealthInput(input);
    if (validationError != null) {
      state = state.copyWith(failure: ValidationFailure(validationError));
      return false;
    }

    state = state.copyWith(isLoading: true, failure: null);
    final result = await ref.read(authRepositoryProvider).updateMyProfile(input);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (profile) {
        state = state.copyWith(isLoading: false, profile: profile, failure: null);
        return true;
      },
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }

  String? _validateHealthInput(HealthProfileInput input) {
    if (input.height <= 0 || input.height > 300) return 'Please enter a valid height.';
    if (input.weight <= 0 || input.weight > 500) return 'Please enter a valid weight.';
    if (input.age <= 0 || input.age > 120) return 'Please enter a valid age.';
    return null;
  }
}

@riverpod
Future<HealthMetrics> healthMetrics(HealthMetricsRef ref) async {
  final result = await ref.watch(authRepositoryProvider).getMyHealth();
  // Surfacing the Failure object itself (not a string) lets `.when(error: ...)`
  // in the UI branch on the concrete failure type if it needs to.
  return result.fold((failure) => throw failure, (metrics) => metrics);
}
