import '../../../../core/database/app_database.dart';
import '../models/todo_model.dart';

/// Interface for local data source (Sqflite)
abstract class TodoLocalDataSource {
  /// Get all todos from local database
  Future<List<TodoModel>> getTodos();

  /// Upsert a todo in the local database ONLY (no outbox).
  /// Used for server pulls and internal cache updates.
  Future<void> upsertTodo(TodoModel todo);

  /// Save a todo locally AND add to the Sync Outbox.
  /// Used for user-initiated actions.
  Future<void> saveTodo(TodoModel todo);

  /// Soft delete a todo locally
  Future<void> deleteTodo(String syncId);

  /// Get all pending sync actions from the outbox
  Future<List<SyncOutboxTableData>> getPendingSyncActions();

  /// Remove an action from the outbox
  Future<void> removeFromOutbox(int id);

  /// Update an outbox entry with error details
  Future<void> updateOutboxError(int id, String error);

  /// Mark todo as synced
  Future<void> markAsSynced(String syncId);

  /// Get last sync timestamp
  Future<String?> getLastSyncTime();

  /// Save last sync timestamp
  Future<void> cacheLastSyncTime(String timestamp);

  /// Watch todos for changes
  Stream<List<TodoModel>> watchTodos();

  /// Delete all todos from local database (DEBUG)
  Future<void> deleteAllTodos();

  /// Delete a todo permanently (from local cache if needed, though usually we keep soft deleted)
  /// But for sync cleanup, we might need it. For now, strictly soft delete.
}
