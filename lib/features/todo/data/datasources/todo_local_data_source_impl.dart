import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/app_logger.dart';
import './todo_local_data_source.dart';
import '../models/todo_model.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final AppDatabase db;

  TodoLocalDataSourceImpl(this.db);

  @override
  Future<List<TodoModel>> getTodos() async {
    AppLogger.database('QUERY', 'Fetching all non-deleted todos');
    final results = await (db.select(db.todos)
          ..where((t) => t.isDeleted.equals(false)))
        .get();
    return results.map((e) => _mapToModel(e)).toList();
  }

  @override
  Stream<List<TodoModel>> watchTodos() {
    AppLogger.database('WATCH', 'Watching non-deleted todos');
    return (db.select(db.todos)..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((e) => _mapToModel(e)).toList());
  }

  @override
  Future<void> upsertTodo(TodoModel todo) async {
    AppLogger.database('UPSERT', 'Local-only write for: ${todo.syncId}');
    await db.into(db.todos).insertOnConflictUpdate(
          TodosCompanion.insert(
            syncId: todo.syncId,
            title: todo.title,
            description: Value(todo.description),
            isCompleted: Value(todo.isCompleted),
            isDeleted: Value(todo.isDeleted),
            version: Value(todo.version),
            createdAt: todo.createdAt,
            updatedAt: todo.updatedAt,
            isSynced: Value(todo.isSynced),
          ),
        );
  }

  @override
  Future<void> saveTodo(TodoModel todo) async {
    AppLogger.database(
        'TRANSACTION', 'Starting atomic save for: ${todo.syncId}');

    await db.transaction(() async {
      // 1. Save to main table
      await upsertTodo(todo);

      // 2. Add to Outbox
      final action = todo.version == 1 ? SyncAction.create : SyncAction.update;
      await db.into(db.syncOutbox).insert(
            SyncOutboxCompanion.insert(
              syncId: todo.syncId,
              action: action,
              payload: todo.toJsonString(),
              createdAt: DateTime.now(),
            ),
          );
      AppLogger.database('OUTBOX', 'Added $action action for ${todo.syncId}');
    });
  }

  @override
  Future<void> deleteTodo(String syncId) async {
    AppLogger.database(
        'TRANSACTION', 'Starting atomic soft-delete for: $syncId');

    await db.transaction(() async {
      // 1. Mark as deleted in main table
      final todoRows = await (db.select(db.todos)
            ..where((t) => t.syncId.equals(syncId)))
          .get();
      if (todoRows.isEmpty) return;

      final currentTodo = _mapToModel(todoRows.first);
      final deletedTodo = currentTodo.copyWith(
          isDeleted: true, isSynced: false, updatedAt: DateTime.now());

      await (db.update(db.todos)..where((t) => t.syncId.equals(syncId))).write(
        TodosCompanion(
          isDeleted: const Value(true),
          isSynced: const Value(false),
          updatedAt: Value(deletedTodo.updatedAt),
        ),
      );

      // 2. Add 'delete' action to Outbox
      await db.into(db.syncOutbox).insert(
            SyncOutboxCompanion.insert(
              syncId: syncId,
              action: SyncAction.delete,
              payload: deletedTodo.toJsonString(),
              createdAt: DateTime.now(),
            ),
          );
      AppLogger.database('OUTBOX', 'Added delete action for $syncId');
    });
  }

  @override
  Future<void> deleteAllTodos() async {
    AppLogger.database('DELETE_ALL', 'Wiping all local todos and outbox');
    await db.transaction(() async {
      await db.delete(db.todos).go();
      await db.delete(db.syncOutbox).go();
    });
  }

  @override
  Future<List<SyncOutboxTableData>> getPendingSyncActions() async {
    AppLogger.database('QUERY', 'Fetching pending actions from outbox');
    return await db.select(db.syncOutbox).get();
  }

  @override
  Future<void> removeFromOutbox(int id) async {
    AppLogger.database('OUTBOX_CLEAN', 'Removing action $id from outbox');
    await (db.delete(db.syncOutbox)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> updateOutboxError(int id, String error) async {
    AppLogger.database('OUTBOX_ERROR', 'Updating error for action $id');
    await (db.update(db.syncOutbox)..where((t) => t.id.equals(id))).write(
      SyncOutboxCompanion(
        lastError: Value(error),
        retryCount: Value(await _getNextRetryCount(id)),
      ),
    );
  }

  Future<int> _getNextRetryCount(int id) async {
    final entry = await (db.select(db.syncOutbox)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return entry.retryCount + 1;
  }

  @override
  Future<String?> getLastSyncTime() async {
    AppLogger.database('METADATA', 'Fetching last sync time');
    final result = await (db.select(db.syncMetadata)
          ..where((t) => t.key.equals('last_sync_time')))
        .getSingleOrNull();
    return result?.value;
  }

  @override
  Future<void> cacheLastSyncTime(String timestamp) async {
    AppLogger.database('METADATA', 'Caching last sync time: $timestamp');
    await db.into(db.syncMetadata).insertOnConflictUpdate(
          SyncMetadataCompanion.insert(key: 'last_sync_time', value: timestamp),
        );
  }

  @override
  Future<void> markAsSynced(String syncId) async {
    AppLogger.database(
        'SYNC_UPDATE', 'Marking todo as synced in main table: $syncId');
    await (db.update(db.todos)..where((t) => t.syncId.equals(syncId))).write(
      const TodosCompanion(isSynced: Value(true)),
    );
  }

  /// Helper to map Drift generated data class to our TodoModel
  TodoModel _mapToModel(TodoTableData data) {
    return TodoModel(
      syncId: data.syncId,
      title: data.title,
      description: data.description,
      isCompleted: data.isCompleted,
      isDeleted: data.isDeleted,
      version: data.version,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isSynced: data.isSynced,
    );
  }
}
