import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/sync_todos.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late SyncTodos usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = SyncTodos(mockRepository);
  });

  test('should call syncTodos on the repository', () async {
    // arrange
    when(() => mockRepository.syncTodos())
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(null)));
    verify(() => mockRepository.syncTodos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
