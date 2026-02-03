import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_offline_first_app/features/todo/data/models/todo_model.dart';
import 'package:todo_offline_first_app/features/todo/domain/entities/todo.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  test('TodoModel should be a subclass of Todo entity', () {
    expect(tTodoModel1, isA<Todo>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'syncId': '8681cc01-ee2d-4dd3-9721-e37456d2524d',
        'title': 'Test Todo 1',
        'description': 'Description 1',
        'isCompleted': false,
        'isDeleted': false,
        'version': 1,
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isSynced': true,
      };

      // act
      final result = TodoModel.fromJson(jsonMap);

      // assert
      expect(result, equals(tTodoModel1));
    });
    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // act
        final result = tTodoModel1.toJson();

        // assert
        final expectedMap = {
          'syncId': '8681cc01-ee2d-4dd3-9721-e37456d2524d',
          'title': 'Test Todo 1',
          'description': 'Description 1',
          'isCompleted': false,
          'isDeleted': false,
          'version': 1,
          'createdAt': '2023-01-01T00:00:00.000',
          'updatedAt': '2023-01-01T00:00:00.000',
          'isSynced': true,
        };
        expect(result, equals(expectedMap));
      });
    });

    group('JSON string serialization', () {
      test('toJsonString should return a valid JSON string', () {
        final jsonStr = tTodoModel1.toJsonString();
        final decoded = json.decode(jsonStr);
        expect(decoded['syncId'], '8681cc01-ee2d-4dd3-9721-e37456d2524d');
      });

      test('fromJsonString should return a valid model', () {
        final jsonStr = json.encode(tTodoModel1.toJson());
        final result = TodoModel.fromJsonString(jsonStr);
        expect(result, equals(tTodoModel1));
      });
    });
  });
}
