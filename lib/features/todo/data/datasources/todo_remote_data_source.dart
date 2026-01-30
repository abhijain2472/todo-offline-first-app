import '../models/sync_response_model.dart';
import '../models/todo_model.dart';

/// Interface for remote data source (API)
abstract class TodoRemoteDataSource {
  /// Get all active todos from server
  Future<List<TodoModel>> getTodos();

  /// Create a new todo on server
  /// [todo] - The todo model with client-generated syncId
  Future<TodoModel> createTodo(TodoModel todo);

  /// Update a todo on server
  Future<TodoModel> updateTodo(TodoModel todo);

  /// Soft delete a todo on server
  Future<void> deleteTodo(String syncId);

  /// Sync todos with server
  /// [since] - Optional timestamp to fetch changes after
  Future<SyncResponseModel> syncTodos({String? since});
}
