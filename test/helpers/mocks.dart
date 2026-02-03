import 'package:mocktail/mocktail.dart';
import 'package:todo_offline_first_app/core/network/network_client.dart';
import 'package:todo_offline_first_app/core/sync/sync_manager.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/watch_todos.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/sync_todos.dart';
import 'package:todo_offline_first_app/features/todo/domain/usecases/clear_local_data.dart';
import 'package:todo_offline_first_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_offline_first_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_offline_first_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_offline_first_app/core/network/network_info.dart';
import 'package:uuid/uuid.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockNetworkClient extends Mock implements NetworkClient {}

class MockSyncManager extends Mock implements SyncManager {}

class MockCreateTodo extends Mock implements CreateTodo {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class MockGetTodos extends Mock implements GetTodos {}

class MockWatchTodos extends Mock implements WatchTodos {}

class MockSyncTodos extends Mock implements SyncTodos {}

class MockClearLocalData extends Mock implements ClearLocalData {}

class MockUuid extends Mock implements Uuid {}
