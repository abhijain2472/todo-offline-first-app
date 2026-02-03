import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/get_todos.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late GetTodos usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = GetTodos(mockRepository);
  });

  test('should get todos from the repository', () async {
    // arrange
    when(() => mockRepository.getTodos())
        .thenAnswer((_) async => Right(tTodoList));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(Right(tTodoList)));
    verify(() => mockRepository.getTodos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
