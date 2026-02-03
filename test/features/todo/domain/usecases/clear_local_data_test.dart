import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/clear_local_data.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late ClearLocalData usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = ClearLocalData(mockRepository);
  });

  test('should call clearLocalData on the repository', () async {
    // arrange
    when(() => mockRepository.clearLocalData())
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(null)));
    verify(() => mockRepository.clearLocalData()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
