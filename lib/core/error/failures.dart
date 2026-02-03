import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure for server-side errors
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure for network/connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for local database errors
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure for sync-related errors
class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

/// Failure for 404 Not Found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Failure for 409 Conflict errors (e.g., syncId already exists)
class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}
