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
  Future<void> saveTodo(TodoModel todo) async {
    AppLogger.database('UPSERT', 'Saving todo: ${todo.syncId}');
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
  Future<void> deleteTodo(String syncId) async {
    AppLogger.database('SOFT_DELETE', 'Marking todo as deleted: $syncId');
    await (db.update(db.todos)..where((t) => t.syncId.equals(syncId))).write(
      const TodosCompanion(isDeleted: Value(true), isSynced: Value(false)),
    );
  }

  @override
  Future<List<TodoModel>> getUnsyncedTodos() async {
    AppLogger.database('QUERY', 'Fetching unsynced todos');
    final results = await (db.select(db.todos)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return results.map((e) => _mapToModel(e)).toList();
  }

  @override
  Future<void> markAsSynced(String syncId) async {
    AppLogger.database('SYNC_UPDATE', 'Marking todo as synced: $syncId');
    await (db.update(db.todos)..where((t) => t.syncId.equals(syncId))).write(
      const TodosCompanion(isSynced: Value(true)),
    );
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
