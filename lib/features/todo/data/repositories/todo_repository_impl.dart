import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/sync/sync_manager.dart';

import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';
import '../models/todo_model.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final SyncManager syncManager;
  final NetworkInfo networkInfo;
  final Uuid uuid; // For generating IDs

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.syncManager,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      // 1. Always return local data first (Offline-first)
      final localTodos = await localDataSource.getTodos();

      // 2. Trigger sync in background if connected
      if (await networkInfo.isConnected) {
        syncManager.sync(); // Fire and forget
      }

      return Right(localTodos);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<List<Todo>> watchTodos() {
    return localDataSource.watchTodos();
  }

  @override
  Future<Either<Failure, Todo>> createTodo({
    required String title,
    String description = '',
  }) async {
    try {
      final now = DateTime.now();
      final String syncId = uuid.v4(); // Client-generated UUID

      final newTodo = TodoModel(
        syncId: syncId,
        title: title,
        description: description,
        isCompleted: false,
        isDeleted: false,
        version: 1, // Start version 1
        createdAt: now,
        updatedAt: now,
        isSynced: false, // Not synced yet
      );

      // 1. Save locally
      await localDataSource.saveTodo(newTodo);

      // 2. Try to sync immediately (optimistic)
      if (await networkInfo.isConnected) {
        syncManager.pushLocalChanges(); // Fire and forget or await?
        // We return the local one immediately for UI speed
      }

      return Right(newTodo);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final updatedTodo = TodoModel(
        syncId: todo.syncId,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        isDeleted: todo.isDeleted,
        version: todo.version + 1, // Increment version for conflict resolution
        createdAt: todo.createdAt,
        updatedAt: DateTime.now(), // Update local timestamp
        isSynced: false, // Mark unsynced
      );

      await localDataSource.saveTodo(updatedTodo);

      if (await networkInfo.isConnected) {
        syncManager.pushLocalChanges();
      }

      return Right(updatedTodo);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String syncId) async {
    try {
      await localDataSource.deleteTodo(syncId); // Soft deletes locally

      if (await networkInfo.isConnected) {
        syncManager.pushLocalChanges();
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncTodos() async {
    try {
      await syncManager.sync();
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalData() async {
    try {
      await localDataSource.deleteAllTodos();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
