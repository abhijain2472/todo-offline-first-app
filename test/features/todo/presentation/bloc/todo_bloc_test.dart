import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_offline_first_app/core/error/failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_offline_first_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_offline_first_app/features/todo/presentation/bloc/todo_state.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late TodoBloc bloc;
  late MockGetTodos mockGetTodos;
  late MockCreateTodo mockCreateTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;
  late MockWatchTodos mockWatchTodos;
  late MockSyncTodos mockSyncTodos;
  late MockClearLocalData mockClearLocalData;

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockCreateTodo = MockCreateTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();
    mockWatchTodos = MockWatchTodos();
    mockSyncTodos = MockSyncTodos();
    mockClearLocalData = MockClearLocalData();

    bloc = TodoBloc(
      getTodos: mockGetTodos,
      createTodo: mockCreateTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
      watchTodos: mockWatchTodos,
      syncTodos: mockSyncTodos,
      clearLocalData: mockClearLocalData,
    );
  });

  test('initial state should be TodoInitial', () {
    expect(bloc.state, equals(TodoInitial()));
  });

  blocTest<TodoBloc, TodoState>(
    'emits [TodoLoading, TodoLoaded] when LoadTodosEvent is added',
    build: () {
      when(() => mockGetTodos()).thenAnswer((_) async => Right(tTodoList));
      when(() => mockWatchTodos()).thenAnswer((_) => Stream.value(tTodoList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTodosEvent()),
    expect: () => [
      TodoLoading(),
      TodoLoaded(todos: tTodoList),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'emits [TodoLoading, TodoError] when getTodos fails',
    build: () {
      when(() => mockGetTodos())
          .thenAnswer((_) async => const Left(ServerFailure('Error')));
      when(() => mockWatchTodos()).thenAnswer((_) => Stream.empty());
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTodosEvent()),
    expect: () => [
      TodoLoading(),
      const TodoError('Error'),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'should call CreateTodo use case when AddTodoEvent is added',
    build: () {
      when(() => mockCreateTodo(
              title: any(named: 'title'),
              description: any(named: 'description')))
          .thenAnswer((_) async => Right(tTodo1));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const AddTodoEvent(title: 'Title', description: 'Desc')),
    verify: (_) {
      verify(() => mockCreateTodo(title: 'Title', description: 'Desc'))
          .called(1);
    },
  );

  blocTest<TodoBloc, TodoState>(
    'should call SyncTodos use case when SyncTodosEvent is added',
    build: () {
      when(() => mockGetTodos()).thenAnswer((_) async => Right(tTodoList));
      when(() => mockWatchTodos()).thenAnswer((_) => Stream.value(tTodoList));
      // First load to be in TodoLoaded state
      bloc.add(LoadTodosEvent());

      when(() => mockSyncTodos()).thenAnswer((_) async => const Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(SyncTodosEvent()),
    verify: (_) {
      verify(() => mockSyncTodos()).called(1);
    },
  );
}
