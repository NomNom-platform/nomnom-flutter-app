/// Typed failure hierarchy shared by every feature's data layer.
///
/// UI code should switch on the concrete subtype instead of comparing
/// strings, so it can react differently (e.g. show a retry button on
/// [NetworkFailure], redirect to login on [UnauthorizedFailure]).
sealed class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Cannot reach the server. Please check your connection.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The server took too long to respond.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid credentials or session expired.'])
      : super(statusCode: 401);
}

class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'This resource already exists.']) : super(statusCode: 409);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Requested resource was not found.']) : super(statusCode: 404);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.statusCode = 400});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.']);
}
