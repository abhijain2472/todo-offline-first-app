import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/sync_todos.dart';
import '../../domain/usecases/update_todo.dart';
import './todo_event.dart';
import './todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final SyncTodos syncTodos;

  TodoBloc({
    required this.getTodos,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.syncTodos,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ToggleTodoCompletionEvent>(_onToggleTodoCompletion);
    on<SyncTodosEvent>(_onSyncTodos);
  }

  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    AppLogger.bloc('LoadTodos', 'Loading...');

    final result = await getTodos();

    result.fold(
      (failure) {
        AppLogger.bloc('LoadTodos', 'Error: ${failure.message}');
        emit(TodoError(failure.message));
      },
      (todos) {
        AppLogger.bloc('LoadTodos', 'Loaded ${todos.length} todos');
        emit(TodoLoaded(todos: todos));
      },
    );
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      // Optimistic update could go here, but we rely on repository return
    }

    AppLogger.bloc('AddTodo', 'Adding: ${event.title}');

    final result = await createTodo(
      title: event.title,
      description: event.description,
    );

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todo) {
        AppLogger.bloc('AddTodo', 'Success');
        add(LoadTodosEvent()); // Reload to get fresh list
      },
    );
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    AppLogger.bloc('UpdateTodo', 'Updating ${event.todo.title}');

    final result = await updateTodo(event.todo);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        AppLogger.bloc('UpdateTodo', 'Success');
        add(LoadTodosEvent());
      },
    );
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    AppLogger.bloc('DeleteTodo', 'Deleting ${event.syncId}');

    final result = await deleteTodo(event.syncId);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        AppLogger.bloc('DeleteTodo', 'Success');
        add(LoadTodosEvent());
      },
    );
  }

  Future<void> _onToggleTodoCompletion(
    ToggleTodoCompletionEvent event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTodo = event.todo.copyWith(
      isCompleted: !event.todo.isCompleted,
    );

    add(UpdateTodoEvent(updatedTodo));
  }

  Future<void> _onSyncTodos(
    SyncTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    AppLogger.bloc('SyncTodos', 'Starting sync...');

    final result = await syncTodos();

    result.fold(
      (failure) {
        AppLogger.bloc('SyncTodos', 'Failed: ${failure.message}');
        if (state is TodoLoaded) {
          emit((state as TodoLoaded).copyWith(isSyncing: false));
        } else {
          emit(TodoError(failure.message));
        }
      },
      (_) {
        AppLogger.bloc('SyncTodos', 'Success');
        if (state is TodoLoaded) {
          emit((state as TodoLoaded).copyWith(isSyncing: false));
        }
        add(LoadTodosEvent()); // Refresh data after sync
      },
    );
  }
}
