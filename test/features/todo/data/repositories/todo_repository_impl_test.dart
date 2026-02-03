import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/core/error/failures.dart';
import 'package:todo_offline_first_app/features/todo/data/repositories/todo_repository_impl.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDataSource mockLocalDataSource;
  late MockTodoRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockSyncManager mockSyncManager;
  late MockUuid mockUuid;

  setUp(() {
    mockLocalDataSource = MockTodoLocalDataSource();
    mockRemoteDataSource = MockTodoRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSyncManager = MockSyncManager();
    mockUuid = MockUuid();

    repository = TodoRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
      syncManager: mockSyncManager,
      uuid: mockUuid,
    );

    // Default mock behavior
    registerFallbackValue(tTodoModel1);
  });

  group('getTodos', () {
    test('should return local todos when getTodos is called', () async {
      // arrange
      when(() => mockLocalDataSource.getTodos())
          .thenAnswer((_) async => tTodoModelList);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getTodos();

      // assert
      expect(result, equals(Right(tTodoModelList)));
      verify(() => mockLocalDataSource.getTodos()).called(1);
    });

    test('should return CacheFailure when local data source fails', () async {
      // arrange
      when(() => mockLocalDataSource.getTodos())
          .thenThrow(Exception('DB Error'));

      // act
      final result = await repository.getTodos();

      // assert
      expect(result, equals(const Left(CacheFailure('Exception: DB Error'))));
    });
  });

  group('createTodo', () {
    test('should save todo locally and trigger sync if connected', () async {
      // arrange
      when(() => mockUuid.v4()).thenReturn('uuid-1');
      when(() => mockLocalDataSource.saveTodo(any()))
          .thenAnswer((_) async => {});
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockSyncManager.pushLocalChanges())
          .thenAnswer((_) async => {});

      // act
      final result =
          await repository.createTodo(title: 'Title', description: 'Desc');

      // assert
      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.saveTodo(any())).called(1);
      verify(() => mockSyncManager.pushLocalChanges()).called(1);
    });

    test('should save todo locally but NOT trigger sync if disconnected',
        () async {
      // arrange
      when(() => mockUuid.v4()).thenReturn('uuid-1');
      when(() => mockLocalDataSource.saveTodo(any()))
          .thenAnswer((_) async => {});
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result =
          await repository.createTodo(title: 'Title', description: 'Desc');

      // assert
      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.saveTodo(any())).called(1);
      verifyNever(() => mockSyncManager.pushLocalChanges());
    });
  });

  group('watchTodos', () {
    test('should return stream from local data source', () {
      // arrange
      when(() => mockLocalDataSource.watchTodos())
          .thenAnswer((_) => Stream.value(tTodoModelList));

      // act
      final stream = repository.watchTodos();

      // assert
      expect(stream, emits(tTodoModelList));
    });
  });
}
