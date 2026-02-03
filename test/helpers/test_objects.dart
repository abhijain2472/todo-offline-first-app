import 'package:todo_offline_first_app/features/todo/domain/entities/todo.dart';
import 'package:todo_offline_first_app/features/todo/data/models/todo_model.dart';

final tTodo1 = Todo(
  syncId: '8681cc01-ee2d-4dd3-9721-e37456d2524d',
  title: 'Test Todo 1',
  description: 'Description 1',
  isCompleted: false,
  createdAt: DateTime(2023, 1, 1),
  updatedAt: DateTime(2023, 1, 1),
  isSynced: true,
);

final tTodo2 = Todo(
  syncId: '4979e8c4-11e4-447a-aec2-f8c6b75883d6',
  title: 'Test Todo 2',
  description: 'Description 2',
  isCompleted: true,
  createdAt: DateTime(2023, 1, 1),
  updatedAt: DateTime(2023, 1, 1),
  isSynced: true,
);

final tTodoList = [tTodo1, tTodo2];

final tTodoModel1 = TodoModel(
  syncId: '8681cc01-ee2d-4dd3-9721-e37456d2524d',
  title: 'Test Todo 1',
  description: 'Description 1',
  isCompleted: false,
  createdAt: DateTime(2023, 1, 1),
  updatedAt: DateTime(2023, 1, 1),
  isSynced: true,
  version: 1,
);

final tTodoModel2 = TodoModel(
  syncId: '4979e8c4-11e4-447a-aec2-f8c6b75883d6',
  title: 'Test Todo 2',
  description: 'Description 2',
  isCompleted: true,
  createdAt: DateTime(2023, 1, 1),
  updatedAt: DateTime(2023, 1, 1),
  isSynced: true,
  version: 1,
);

final tTodoModelList = [tTodoModel1, tTodoModel2];
