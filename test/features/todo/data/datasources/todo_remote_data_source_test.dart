import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/core/network/network_client.dart';
import 'package:todo_offline_first_app/core/constants/constants.dart';
import 'package:todo_offline_first_app/features/todo/data/datasources/todo_remote_data_source_impl.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  late TodoRemoteDataSourceImpl dataSource;
  late MockNetworkClient mockNetworkClient;

  setUp(() {
    mockNetworkClient = MockNetworkClient();
    dataSource = TodoRemoteDataSourceImpl(client:mockNetworkClient);
  });

  group('getTodos', () {
    test('should return list of TodoModels when status code is 200', () async {
      // arrange
      when(() => mockNetworkClient.get(Apis.todos)).thenAnswer(
        (_) async => NetworkResponse(
          statusCode: 200,
          body: '[${tTodoModel1.toJsonString()},${tTodoModel2.toJsonString()}]',
          headers: {},
        ),
      );

      // act
      final result = await dataSource.getTodos();

      // assert
      expect(result, equals(tTodoModelList));
    });
  });

  group('createTodo', () {
    test('should return TodoModel when created successfully', () async {
      // arrange
      when(() => mockNetworkClient.post(Apis.todos, body: any(named: 'body')))
          .thenAnswer(
        (_) async => NetworkResponse(
          statusCode: 201,
          body: tTodoModel1.toJsonString(),
          headers: {},
        ),
      );

      // act
      final result = await dataSource.createTodo(tTodoModel1);

      // assert
      expect(result, equals(tTodoModel1));
    });
  });
}
