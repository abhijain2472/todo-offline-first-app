import 'package:flutter_test/flutter_test.dart';
import 'package:todo_offline_first_app/features/todo/domain/entities/todo.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  test('Todo entity should support equality', () {
    final todo1 = tTodo1;
    final todo2 = tTodo1;
    final todo3 = tTodo2;

    expect(todo1, equals(todo2));
    expect(todo1, isNot(equals(todo3)));
  });

  test('copyWith should return a new Todo with updated fields', () {
    final original = tTodo1;
    final updated = original.copyWith(title: 'Updated Title');

    expect(updated.title, equals('Updated Title'));
    expect(updated.syncId, equals(original.syncId));
    expect(updated.description, equals(original.description));
  });

  test('Todo properties should be correctly assigned', () {
    final now = DateTime.now();
    final todo = Todo(
      syncId: 'id',
      title: 'title',
      description: 'desc',
      isCompleted: true,
      isDeleted: false,
      version: 2,
      createdAt: now,
      updatedAt: now,
      isSynced: true,
    );

    expect(todo.syncId, 'id');
    expect(todo.title, 'title');
    expect(todo.description, 'desc');
    expect(todo.isCompleted, true);
    expect(todo.isDeleted, false);
    expect(todo.version, 2);
    expect(todo.createdAt, now);
    expect(todo.updatedAt, now);
    expect(todo.isSynced, true);
  });
}
