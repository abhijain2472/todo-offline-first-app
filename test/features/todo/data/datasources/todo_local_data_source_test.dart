import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_offline_first_app/core/database/app_database.dart';
import 'package:todo_offline_first_app/features/todo/data/datasources/todo_local_data_source_impl.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late AppDatabase db;
  late TodoLocalDataSourceImpl dataSource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dataSource = TodoLocalDataSourceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TodoLocalDataSourceImpl', () {
    test('getTodos should return empty list when db is empty', () async {
      final result = await dataSource.getTodos();
      expect(result, isEmpty);
    });

    test('upsertTodo should save a todo to the database', () async {
      // arrange
      await dataSource.upsertTodo(tTodoModel1);

      // act
      final result = await dataSource.getTodos();

      // assert
      expect(result.length, 1);
      expect(result.first.syncId, tTodoModel1.syncId);
    });

    test('saveTodo should save todo AND add entry to sync outbox', () async {
      // act
      await dataSource.saveTodo(tTodoModel1);

      // assert - check todo saved
      final todos = await dataSource.getTodos();
      expect(todos.length, 1);

      // assert - check outbox
      final outbox = await dataSource.getPendingSyncActions();
      expect(outbox.length, 1);
      expect(outbox.first.syncId, tTodoModel1.syncId);
      expect(outbox.first.action, SyncAction.create);
    });

    test('watchTodos should emit new list when data changes', () async {
      final stream = dataSource.watchTodos();

      expect(
          stream,
          emitsInOrder([
            isEmpty,
            [tTodoModel1],
          ]));

      // Give the stream time to emit the initial empty state
      await Future.delayed(const Duration(milliseconds: 100));
      await dataSource.upsertTodo(tTodoModel1);
    });

    test('deleteTodo should mark as deleted and add to outbox', () async {
      // arrange
      await dataSource.upsertTodo(tTodoModel1);

      // act
      await dataSource.deleteTodo(tTodoModel1.syncId);

      // assert - should be filtered from getTodos
      final todos = await dataSource.getTodos();
      expect(todos, isEmpty);

      // assert - should be in outbox as delete action
      final outbox = await dataSource.getPendingSyncActions();
      expect(
          outbox.any((element) => element.action == SyncAction.delete), true);
    });

    test('deleteAllTodos should wipe everything', () async {
      // arrange
      await dataSource.saveTodo(tTodoModel1);

      // act
      await dataSource.deleteAllTodos();

      // assert
      expect(await dataSource.getTodos(), isEmpty);
      expect(await dataSource.getPendingSyncActions(), isEmpty);
    });

    test('markAsSynced should update isSynced flag', () async {
      // arrange
      final unsynced = tTodoModel1.copyWith(isSynced: false);
      await dataSource.upsertTodo(unsynced);

      // act
      await dataSource.markAsSynced(unsynced.syncId);

      // assert
      final todos = await dataSource.getTodos();
      expect(todos.first.isSynced, true);
    });

    group('Sync Outbox Management', () {
      test('removeFromOutbox should delete entry', () async {
        await dataSource.saveTodo(tTodoModel1);
        final outboxBefore = await dataSource.getPendingSyncActions();

        await dataSource.removeFromOutbox(outboxBefore.first.id);

        final outboxAfter = await dataSource.getPendingSyncActions();
        expect(outboxAfter, isEmpty);
      });

      test('updateOutboxError should increment retry count and set error',
          () async {
        await dataSource.saveTodo(tTodoModel1);
        final entry = (await dataSource.getPendingSyncActions()).first;

        await dataSource.updateOutboxError(entry.id, 'Network Fail');

        final updated = (await dataSource.getPendingSyncActions()).first;
        expect(updated.retryCount, 1);
        expect(updated.lastError, 'Network Fail');
      });
    });

    group('Sync Metadata', () {
      test('cacheLastSyncTime and getLastSyncTime', () async {
        final time = DateTime.now().toIso8601String();

        await dataSource.cacheLastSyncTime(time);
        final result = await dataSource.getLastSyncTime();

        expect(result, time);
      });
    });
  });
}
