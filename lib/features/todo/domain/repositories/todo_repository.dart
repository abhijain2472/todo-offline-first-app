import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/todo.dart';

/// Repository interface for Todo operations
///
/// This defines the contract for data operations.
/// The actual implementation will be in the data layer.
abstract class TodoRepository {
  /// Get all active todos (not deleted)
  Future<Either<Failure, List<Todo>>> getTodos();

  /// Create a new todo
  /// [title] - The title of the todo
  /// [description] - Optional description
  Future<Either<Failure, Todo>> createTodo({
    required String title,
    String description = '',
  });

  /// Update an existing todo
  Future<Either<Failure, Todo>> updateTodo(Todo todo);

  /// Delete a todo (soft delete)
  Future<Either<Failure, void>> deleteTodo(String syncId);

  /// Sync todos with the server
  Future<Either<Failure, void>> syncTodos();

  /// Get real-time stream of todos
  Stream<List<Todo>> watchTodos();

  /// Clear all local todo data (DEBUG)
  Future<Either<Failure, void>> clearLocalData();
}
