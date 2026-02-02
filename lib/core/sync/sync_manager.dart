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

  bool _isSyncing = false;

  SyncManager({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Main sync method
  Future<void> sync() async {
    if (_isSyncing) {
      AppLogger.sync('SKIP', 'Sync already in progress, ignoring request');
      return;
    }

    _isSyncing = true;
    AppLogger.sync('START', 'Starting synchronization process');

    if (!await networkInfo.isConnected) {
      AppLogger.sync('SKIP', 'No internet connection, cannot sync');
      _isSyncing = false;
      return;
    }

    try {
      _updateStatus(SyncStatus.syncing);

      // 1. Push local changes
      AppLogger.sync('PUSH_START', 'Pushing unsynced local changes');
      await _internalPushLocalChanges();

      // 2. Pull server changes
      AppLogger.sync('PULL_START', 'Pulling changes from server');
      await _internalPullServerChanges();

      AppLogger.sync('COMPLETE', 'Synchronization finished successfully');
      _updateStatus(SyncStatus.success);
    } catch (e) {
      AppLogger.error('Sync process failed unexpectedly',
          category: 'SYNC', error: e);
      _updateStatus(SyncStatus.failed);
      rethrow;
    } finally {
      _isSyncing = false;
      _updateStatus(SyncStatus.idle);
    }
  }

  void _updateStatus(SyncStatus status) {
    if (_syncStatusController.hasListener) {
      _syncStatusController.add(status);
    }
  }

  /// Public method to push local changes (used by Repository)
  Future<void> pushLocalChanges() async {
    if (_isSyncing) {
      AppLogger.sync('SKIP', 'Sync/Push already in progress, skipping push');
      return;
    }

    _isSyncing = true;
    try {
      await _internalPushLocalChanges();
    } finally {
      _isSyncing = false;
    }
  }

  /// Internal push logic without _isSyncing check
  Future<void> _internalPushLocalChanges() async {
    try {
      final unsyncedTodos = await localDataSource.getUnsyncedTodos();

      if (unsyncedTodos.isEmpty) {
        AppLogger.sync('PUSH', 'No local changes found to push');
        return;
      }

      AppLogger.sync('PUSH', 'Found ${unsyncedTodos.length} unsynced todos');

      for (final todo in unsyncedTodos) {
        try {
          TodoModel syncedTodo;

          if (todo.isDeleted) {
            AppLogger.sync(
                'PUSH_DELETE', 'Deleting todo on server: ${todo.syncId}');
            await remoteDataSource.deleteTodo(todo.syncId);
            await localDataSource.markAsSynced(todo.syncId);
            continue;
          } else if (todo.version == 1 && todo.createdAt == todo.updatedAt) {
            AppLogger.sync(
                'PUSH_CREATE', 'Creating todo on server: ${todo.title}');
            syncedTodo = await remoteDataSource.createTodo(todo);
          } else {
            AppLogger.sync(
                'PUSH_UPDATE', 'Updating todo on server: ${todo.title}');
            syncedTodo = await remoteDataSource.updateTodo(todo);
          }

          // Update local with server response (which includes server version/timestamps)
          await localDataSource.saveTodo(syncedTodo.copyWith(isSynced: true));
          AppLogger.sync('PUSH_SUCCESS', 'Successfully pushed ${todo.syncId}');
        } catch (e) {
          AppLogger.error('Failed to push individual todo ${todo.syncId}',
              category: 'SYNC', error: e);
          // Continue with next todo
        }
      }
    } catch (e) {
      AppLogger.error('Internal push local changes failed',
          category: 'SYNC', error: e);
    }
  }

  /// Internal pull logic without _isSyncing check
  Future<void> _internalPullServerChanges() async {
    try {
      final lastSyncTime = await localDataSource.getLastSyncTime();
      AppLogger.sync('PULL', 'Fetching changes since $lastSyncTime');

      final syncResponse =
          await remoteDataSource.syncTodos(since: lastSyncTime);

      if (syncResponse.changes.isEmpty) {
        AppLogger.sync('PULL', 'No remote changes since last sync');
      } else {
        AppLogger.sync(
            'PULL', 'Received ${syncResponse.changes.length} remote changes');

        for (final remoteTodo in syncResponse.changes) {
          await _processRemoteChange(remoteTodo);
        }
      }

      // Update sync timestamp
      await localDataSource.cacheLastSyncTime(syncResponse.timestamp);
      AppLogger.sync(
          'PULL_COMPLETE', 'Updated last sync time: ${syncResponse.timestamp}');
    } catch (e) {
      AppLogger.error('Internal pull server changes failed',
          category: 'SYNC', error: e);
    }
  }

  Future<void> _processRemoteChange(TodoModel remoteTodo) async {
    // Conflict Resolution Strategy (Simple for now):
    // Server wins if it has a newer or same version, unless we have very specific logic.
    // In this app, we'll just save what comes from the server.

    AppLogger.sync('MERGE',
        'Applying remote update for "${remoteTodo.title}" (${remoteTodo.syncId})');

    // Remote data is already marked isSynced=true in TodoModel.fromJson
    await localDataSource.saveTodo(remoteTodo);
  }
}
