import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/watch_todos.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late WatchTodos usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = WatchTodos(mockRepository);
  });

  test('should get a stream of todos from the repository', () async {
    // arrange
    when(() => mockRepository.watchTodos())
        .thenAnswer((_) => Stream.value(tTodoList));

    // act
    final result = usecase();

    // assert
    expect(result, emits(tTodoList));
    verify(() => mockRepository.watchTodos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
