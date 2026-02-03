import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/create_todo.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late CreateTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = CreateTodo(mockRepository);
  });

  const tTitle = 'Test title';
  const tDescription = 'Test description';

  test('should call createTodo on the repository', () async {
    // arrange
    when(() => mockRepository.createTodo(
            title: any(named: 'title'), description: any(named: 'description')))
        .thenAnswer((_) async => Right(tTodo1));

    // act
    final result = await usecase(title: tTitle, description: tDescription);

    // assert
    expect(result, equals(Right(tTodo1)));
    verify(() =>
            mockRepository.createTodo(title: tTitle, description: tDescription))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
