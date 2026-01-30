import '../models/todo_model.dart';

/// Interface for local data source (Sqflite)
abstract class TodoLocalDataSource {
  /// Get all todos from local database
  Future<List<TodoModel>> getTodos();

  /// Upsert a todo (insert, or update if existing)
  Future<void> saveTodo(TodoModel todo);

  /// Soft delete a todo locally
  Future<void> deleteTodo(String syncId);

  /// Get list of unsynced todos
  Future<List<TodoModel>> getUnsyncedTodos();

  /// Mark todo as synced
  Future<void> markAsSynced(String syncId);

  /// Get last sync timestamp
  Future<String?> getLastSyncTime();

  /// Save last sync timestamp
  Future<void> cacheLastSyncTime(String timestamp);

  /// Delete a todo permanently (from local cache if needed, though usually we keep soft deleted)
  /// But for sync cleanup, we might need it. For now, strictly soft delete.
}
