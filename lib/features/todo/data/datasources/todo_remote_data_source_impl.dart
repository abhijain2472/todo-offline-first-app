import '../../../../core/network/network_client.dart';
import '../../../../core/constants/constants.dart';
import '../models/sync_response_model.dart';
import '../models/todo_model.dart';
import './todo_remote_data_source.dart';

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final NetworkClient client;

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Apis.todos);
    final List<dynamic> jsonList = response.jsonBody;
    return jsonList.map((json) => TodoModel.fromJson(json)).toList();
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await client.post(Apis.todos, body: todo.toJson());
    return TodoModel.fromJson(response.jsonBody);
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response =
        await client.patch('${Apis.todos}/${todo.syncId}', body: todo.toJson());
    return TodoModel.fromJson(response.jsonBody);
  }

  @override
  Future<void> deleteTodo(String syncId) async {
    await client.delete('${Apis.todos}/$syncId');
  }

  @override
  Future<SyncResponseModel> syncTodos({String? since}) async {
    final response = await client.get(
      Apis.sync,
      queryParameters: since != null ? {'since': since} : null,
    );
    return SyncResponseModel.fromJson(response.jsonBody);
  }
}
