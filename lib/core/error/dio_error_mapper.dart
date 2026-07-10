import 'package:dio/dio.dart';
import 'failure.dart';

/// Translates a raised [DioException] into the app's typed [Failure]
/// hierarchy so data layers never leak Dio-specific types past their edge.
Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
      return const NetworkFailure();
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const TimeoutFailure();
    default:
      break;
  }

  final statusCode = e.response?.statusCode;
  final data = e.response?.data;
  String? serverMessage;
  if (data is Map && data['message'] is String) {
    serverMessage = data['message'] as String;
  } else if (data is Map && data['error'] is String) {
    serverMessage = data['error'] as String;
  }

  switch (statusCode) {
    case 401:
      return UnauthorizedFailure(serverMessage ?? 'Invalid email or password.');
    case 409:
      return ConflictFailure(serverMessage ?? 'This email is already registered.');
    case 404:
      return NotFoundFailure(serverMessage ?? 'Requested resource was not found.');
    case 400:
    case 422:
      return ValidationFailure(serverMessage ?? 'Invalid request.', statusCode: statusCode);
  }

  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(serverMessage ?? 'Server error. Please try again later.', statusCode: statusCode);
  }

  return UnknownFailure(serverMessage ?? 'Something went wrong. Please try again.');
}
