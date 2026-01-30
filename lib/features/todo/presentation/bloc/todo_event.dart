import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all todos
class LoadTodosEvent extends TodoEvent {}

/// Event to add a new todo
class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;

  const AddTodoEvent({
    required this.title,
    this.description = '',
  });

  @override
  List<Object?> get props => [title, description];
}

/// Event to update an existing todo
class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  const UpdateTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

/// Event to delete a todo
class DeleteTodoEvent extends TodoEvent {
  final String syncId;

  const DeleteTodoEvent(this.syncId);

  @override
  List<Object?> get props => [syncId];
}

/// Event to toggle completion status
class ToggleTodoCompletionEvent extends TodoEvent {
  final Todo todo;

  const ToggleTodoCompletionEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

/// Event to manually trigger sync
class SyncTodosEvent extends TodoEvent {}
