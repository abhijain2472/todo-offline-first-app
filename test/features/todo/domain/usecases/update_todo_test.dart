import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/update_todo.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late UpdateTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = UpdateTodo(mockRepository);
    registerFallbackValue(tTodo1);
  });

  test('should call updateTodo on the repository', () async {
    // arrange
    when(() => mockRepository.updateTodo(any()))
        .thenAnswer((_) async => Right(tTodo1));

    // act
    final result = await usecase(tTodo1);

    // assert
    expect(result, equals(Right(tTodo1)));
    verify(() => mockRepository.updateTodo(tTodo1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
