import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import './todo_remote_data_source.dart';
import '../models/sync_response_model.dart';
import '../models/todo_model.dart';

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> getTodos() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}');

    AppLogger.api(ApiConstants.todos, 'GET');

    try {
      final response = await client
          .get(
            uri,
            headers: ApiConstants.headers,
          )
          .timeout(ApiConstants.connectionTimeout);

      AppLogger.api(ApiConstants.todos, 'GET', statusCode: response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => TodoModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('Failed to fetch todos: ${response.reasonPhrase}');
      }
    } catch (e) {
      AppLogger.error('GET todos failed', category: 'API', error: e);
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}');

    // Only send required fields for creation
    final body = json.encode({
      'syncId': todo.syncId,
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
    });

    AppLogger.api(ApiConstants.todos, 'POST', data: body);

    try {
      final response = await client
          .post(
            uri,
            headers: ApiConstants.headers,
            body: body,
          )
          .timeout(ApiConstants.connectionTimeout);

      AppLogger.api(ApiConstants.todos, 'POST',
          statusCode: response.statusCode);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return TodoModel.fromJson(responseData);
      } else {
        final error = json.decode(response.body);
        throw ServerFailure(error['message'] ?? 'Failed to create todo');
      }
    } catch (e) {
      AppLogger.error('POST todo failed', category: 'API', error: e);
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.todos}/${todo.syncId}');

    final body = json.encode({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
      'isDeleted': todo.isDeleted,
    });

    AppLogger.api('${ApiConstants.todos}/${todo.syncId}', 'PATCH', data: body);

    try {
      final response = await client
          .patch(
            uri,
            headers: ApiConstants.headers,
            body: body,
          )
          .timeout(ApiConstants.connectionTimeout);

      AppLogger.api('${ApiConstants.todos}/${todo.syncId}', 'PATCH',
          statusCode: response.statusCode);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return TodoModel.fromJson(responseData);
      } else {
        final error = json.decode(response.body);
        throw ServerFailure(error['message'] ?? 'Failed to update todo');
      }
    } catch (e) {
      AppLogger.error('PATCH todo failed', category: 'API', error: e);
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteTodo(String syncId) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}/$syncId');

    AppLogger.api('${ApiConstants.todos}/$syncId', 'DELETE');

    try {
      final response = await client
          .delete(
            uri,
            headers: ApiConstants.headers,
          )
          .timeout(ApiConstants.connectionTimeout);

      AppLogger.api('${ApiConstants.todos}/$syncId', 'DELETE',
          statusCode: response.statusCode);

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw ServerFailure(error['message'] ?? 'Failed to delete todo');
      }
    } catch (e) {
      AppLogger.error('DELETE todo failed', category: 'API', error: e);
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SyncResponseModel> syncTodos({String? since}) async {
    final queryParams = since != null ? '?since=$since' : '';
    final uri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sync}$queryParams');

    AppLogger.api(ApiConstants.sync, 'GET',
        data: since != null ? {'since': since} : null);

    try {
      final response = await client
          .get(
            uri,
            headers: ApiConstants.headers,
          )
          .timeout(ApiConstants.connectionTimeout);

      AppLogger.api(ApiConstants.sync, 'GET', statusCode: response.statusCode);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return SyncResponseModel.fromJson(responseData);
      } else {
        throw ServerFailure('Sync failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      AppLogger.error('Sync failed', category: 'API', error: e);
      throw ServerFailure(e.toString());
    }
  }
}
