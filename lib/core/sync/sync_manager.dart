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
  StreamSubscription? _networkSubscription;
  final DateTime _managerStartTime = DateTime.now();

  SyncManager({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    // Automatically trigger sync when network recovers
    _networkSubscription =
        networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        // Only trigger auto-sync if we have "settled" after startup.
        // This avoids jitter where connectivity_plus reports [none, wifi] on boot.
        final secondsSinceStartup =
            DateTime.now().difference(_managerStartTime).inSeconds;

        if (secondsSinceStartup > 3) {
          AppLogger.sync('AUTO', 'Network recovered, triggering sync');
          sync();
        } else {
          AppLogger.sync('SKIP', 'Ignoring startup network jitter');
        }
      }
    });
  }

  void dispose() {
    _networkSubscription?.cancel();
    _syncStatusController.close();
  }

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

  /// Internal push logic
  Future<void> _internalPushLocalChanges() async {
    try {
      final unsyncedTodos = await localDataSource.getUnsyncedTodos();
      if (unsyncedTodos.isEmpty) {
        AppLogger.sync('PUSH', 'No local changes found to push');
        return;
      }

      AppLogger.sync('PUSH', 'Pushing ${unsyncedTodos.length} unsynced todos');
      for (final todo in unsyncedTodos) {
        await _pushSingleTodo(todo);
      }
    } catch (e) {
      AppLogger.error('Bulk push failed', category: 'SYNC', error: e);
    }
  }

  /// Handles pushing a single todo to the server
  Future<void> _pushSingleTodo(TodoModel todo) async {
    try {
      TodoModel? syncedTodo;

      if (todo.isDeleted) {
        await _handleRemoteDelete(todo);
      } else if (_isNewTodo(todo)) {
        syncedTodo = await _handleRemoteCreate(todo);
      } else {
        syncedTodo = await _handleRemoteUpdate(todo);
      }

      if (syncedTodo != null) {
        await localDataSource.saveTodo(syncedTodo.copyWith(isSynced: true));
      } else if (todo.isDeleted) {
        await localDataSource.markAsSynced(todo.syncId);
      }

      AppLogger.sync('PUSH_SUCCESS', 'Synced ${todo.syncId}');
    } catch (e) {
      AppLogger.error('Push failed for ${todo.syncId}',
          category: 'SYNC', error: e);
    }
  }

  bool _isNewTodo(TodoModel todo) =>
      todo.version == 1 && todo.createdAt == todo.updatedAt;

  Future<void> _handleRemoteDelete(TodoModel todo) async {
    AppLogger.sync('PUSH_DELETE', 'Deleting ${todo.syncId}');
    await remoteDataSource.deleteTodo(todo.syncId);
  }

  Future<TodoModel> _handleRemoteCreate(TodoModel todo) async {
    AppLogger.sync('PUSH_CREATE', 'Creating "${todo.title}"');
    return await remoteDataSource.createTodo(todo);
  }

  Future<TodoModel> _handleRemoteUpdate(TodoModel todo) async {
    AppLogger.sync('PUSH_UPDATE', 'Updating "${todo.title}"');
    return await remoteDataSource.updateTodo(todo);
  }

  /// Internal pull logic
  Future<void> _internalPullServerChanges() async {
    try {
      final lastSyncTime = await localDataSource.getLastSyncTime();
      AppLogger.sync('PULL', 'Fetching changes since $lastSyncTime');

      final syncResponse =
          await remoteDataSource.syncTodos(since: lastSyncTime);

      if (syncResponse.changes.isNotEmpty) {
        AppLogger.sync(
            'PULL', 'Applying ${syncResponse.changes.length} changes');
        for (final remoteTodo in syncResponse.changes) {
          await _processRemoteChange(remoteTodo);
        }
      } else {
        AppLogger.sync('PULL', 'No remote changes found');
      }

      await localDataSource.cacheLastSyncTime(syncResponse.timestamp);
    } catch (e) {
      AppLogger.error('Pull failed', category: 'SYNC', error: e);
    }
  }

  Future<void> _processRemoteChange(TodoModel remoteTodo) async {
    AppLogger.sync('MERGE', 'Remote update for "${remoteTodo.title}"');
    await localDataSource.saveTodo(remoteTodo); // Server wins
  }
}
