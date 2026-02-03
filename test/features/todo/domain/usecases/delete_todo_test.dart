import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/delete_todo.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late DeleteTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = DeleteTodo(mockRepository);
  });

  const tSyncId = 'uuid';

  test('should call deleteTodo on the repository', () async {
    // arrange
    when(() => mockRepository.deleteTodo(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tSyncId);

    // assert
    expect(result, equals(const Right(null)));
    verify(() => mockRepository.deleteTodo(tSyncId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
