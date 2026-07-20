import '../error/failure.dart';

/// Minimal Either-like wrapper so repositories can return typed failures
/// instead of throwing, without pulling in a full functional-programming
/// dependency (fpdart/dartz) for a single use case.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Failure failure) = Fail<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Fail<T>;

  /// Returns the success value, or `null` when this is a [Fail].
  T? get valueOrNull => switch (this) {
        Success<T>(value: final v) => v,
        Fail<T>() => null,
      };

  /// Returns the failure, or `null` when this is a [Success].
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Fail<T>(failure: final f) => f,
      };

  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess) {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      Fail<T>(failure: final f) => onFailure(f),
    };
  }
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Fail<T> extends Result<T> {
  final Failure failure;
  const Fail(this.failure);
}
