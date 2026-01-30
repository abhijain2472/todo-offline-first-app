import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final bool isSyncing; // To show loading indicator without blocking UI

  const TodoLoaded({
    required this.todos,
    this.isSyncing = false,
  });

  /// Create a copy with updated fields
  TodoLoaded copyWith({
    List<Todo>? todos,
    bool? isSyncing,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props => [todos, isSyncing];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

class TodoSyncing
    extends TodoState {} // Optional state if we want full screen sync
