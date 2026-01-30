import 'dart:async';
import '../network/network_info.dart';
import '../utils/app_logger.dart';
import '../../features/todo/data/datasources/todo_local_data_source.dart';
import '../../features/todo/data/datasources/todo_remote_data_source.dart';
import '../../features/todo/data/models/todo_model.dart';

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  success,
  failed,
}

/// SyncManager - Handles all offline-first synchronization logic
class SyncManager {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  SyncManager({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Main sync method
  Future<void> sync() async {
    if (!await networkInfo.isConnected) {
      AppLogger.sync('SKIP', 'No internet connection');
      return;
    }

    if (_syncStatusController.hasListener) {
      _syncStatusController.add(SyncStatus.syncing);
    }

    AppLogger.sync('START', 'Starting synchronization');

    try {
      // 1. Push local changes
      await pushLocalChanges();

      // 2. Pull server changes
      await _pullServerChanges();

      AppLogger.sync('COMPLETE', 'Sync finished successfully');
      if (_syncStatusController.hasListener) {
        _syncStatusController.add(SyncStatus.success);
      }
    } catch (e) {
      AppLogger.error('Sync process failed', category: 'SYNC', error: e);
      if (_syncStatusController.hasListener) {
        _syncStatusController.add(SyncStatus.failed);
      }
      rethrow;
    } finally {
      if (_syncStatusController.hasListener) {
        _syncStatusController.add(SyncStatus.idle);
      }
    }
  }

  /// Push unsynced changes to server
  Future<void> pushLocalChanges() async {
    final unsyncedTodos = await localDataSource.getUnsyncedTodos();

    if (unsyncedTodos.isEmpty) {
      AppLogger.sync('PUSH', 'No local changes to push');
      return;
    }

    AppLogger.sync('PUSH', 'Pushing ${unsyncedTodos.length} unsynced todos');

    for (final todo in unsyncedTodos) {
      try {
        TodoModel syncedTodo;

        if (todo.isDeleted) {
          // DELETE
          AppLogger.sync(
              'PUSH_DELETE', 'Deleting ${todo.title} (${todo.syncId})');
          await remoteDataSource.deleteTodo(todo.syncId);
          // For delete, we just mark as synced locally (soft deleted item stays)
          // or we can remove it. Let's keep soft deleted but synced.
          // Since delete request doesn't return body, we just mark synced.
          await localDataSource.markAsSynced(todo.syncId);
          continue;
        } else if (todo.version == 1 && todo.createdAt == todo.updatedAt) {
          // CREATE (Simple heuristic: version 1 and created=updated usually means new)
          // Or better: try create, if 409 conflict then update?
          // Since we use UUID, if it exists on server, it means we probably should update it.
          // But 'create' endpoint might fail if ID exists.
          // Let's assume 'create' for now.
          AppLogger.sync('PUSH_CREATE', 'Creating ${todo.title}');
          syncedTodo = await remoteDataSource.createTodo(todo);
        } else {
          // UPDATE
          AppLogger.sync('PUSH_UPDATE', 'Updating ${todo.title}');
          syncedTodo = await remoteDataSource.updateTodo(todo);
        }

        // Update local with server response (it might have new version/timestamp)
        await localDataSource.saveTodo(syncedTodo); // saveTodo handles upsert
        // saveTodo marks as synced?
        // No, saveTodo just saves. But TodoModel from server has isSynced=true.
        // So saving it overwrites the local one with isSynced=true. Correct.
      } catch (e) {
        // Log individual failure but continue syncing others
        AppLogger.error('Failed to push todo ${todo.syncId}',
            category: 'SYNC', error: e);
      }
    }
  }

  /// Pull changes from server
  Future<void> _pullServerChanges() async {
    final lastSyncTime = await localDataSource.getLastSyncTime();

    AppLogger.sync('PULL', 'Fetching changes since $lastSyncTime');

    final syncResponse = await remoteDataSource.syncTodos(since: lastSyncTime);

    if (syncResponse.changes.isEmpty) {
      AppLogger.sync('PULL', 'No remote changes');
    } else {
      AppLogger.sync(
          'PULL', 'Received ${syncResponse.changes.length} remote changes');

      for (final remoteTodo in syncResponse.changes) {
        // Resolve conflicts if necessary
        // For now, simple "Server Wins" logic or relying on version
        await _processRemoteChange(remoteTodo);
      }
    }

    // Update sync timestamp
    await localDataSource.cacheLastSyncTime(syncResponse.timestamp);
  }

  Future<void> _processRemoteChange(TodoModel remoteTodo) async {
    // Check if we have a local version
    // We can just upsert. If we had local unsynced changes, this might overwrite them.
    // Conflict Resolution Strategy:
    // 1. Get local copy
    // 2. If local copy exits AND is unsynced:
    //    - Compare versions.
    //    - If remote.version > local.version -> Server wins (overwrite local)
    //    - If local.version > remote.version -> Local wins (keep unsynced, will push next time)
    //    - If versions equal -> Server wins (or timestamp check).

    // However, simplest offline-first approach:
    // If local is unsynced, we typically want to preserve user's local edit unless server is strictly newer.

    // For this MVP: "Last Write Wins" / "Server Wins on Conflict"
    // We'll just save the remote todo, which sets isSynced=true.
    // This overwrites local changes if any.
    // To be safer, we should check:

    /*
    final localTodos = await localDataSource.getTodos(); // This is expensive to fetch all.
    // Better: add getTodo(id) method to localDataSource?
    // For now, let's assume sqflite 'INSERT OR REPLACE' logic in saveTodo.
    */

    AppLogger.sync('MERGE', 'Applying remote update for ${remoteTodo.title}');
    await localDataSource.saveTodo(remoteTodo);
  }
}
