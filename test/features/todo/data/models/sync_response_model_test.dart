import 'package:flutter_test/flutter_test.dart';
import 'package:todo_offline_first_app/features/todo/data/models/sync_response_model.dart';
import '../../../../helpers/test_objects.dart';

void main() {
  final tTimestamp = DateTime(2023, 1, 1).toIso8601String();
  final tSyncResponseModel = SyncResponseModel(
    timestamp: tTimestamp,
    changes: [tTodoModel1],
  );

  group('SyncResponseModel', () {
    test('should be a subclass of Equatable', () {
      expect(tSyncResponseModel, isA<SyncResponseModel>());
    });

    group('fromJson', () {
      test('should return a valid model when the JSON changes is a list', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'timestamp': tTimestamp,
          'changes': [tTodoModel1.toJson()],
        };

        // act
        final result = SyncResponseModel.fromJson(jsonMap);

        // assert
        expect(result, equals(tSyncResponseModel));
      });

      test(
          'should return a valid model with current timestamp and empty changes if fields missing',
          () {
        // arrange
        final Map<String, dynamic> jsonMap = {};

        // act
        final result = SyncResponseModel.fromJson(jsonMap);

        // assert
        expect(result.changes, isEmpty);
        expect(result.timestamp, isA<String>());
      });
    });
  });
}
