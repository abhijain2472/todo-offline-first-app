import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import './core/database/app_database.dart';
import './core/network/network_info.dart';
import './core/network/network_info_impl.dart';
import './core/sync/sync_manager.dart';
import './features/todo/data/datasources/todo_local_data_source.dart';
import './features/todo/data/datasources/todo_local_data_source_impl.dart';
import './features/todo/data/datasources/todo_remote_data_source.dart';
import './features/todo/data/datasources/todo_remote_data_source_impl.dart';
import './features/todo/data/repositories/todo_repository_impl.dart';
import './features/todo/domain/repositories/todo_repository.dart';
import './features/todo/domain/usecases/clear_local_data.dart';
import './features/todo/domain/usecases/create_todo.dart';
import './features/todo/domain/usecases/delete_todo.dart';
import './features/todo/domain/usecases/get_todos.dart';
import './features/todo/domain/usecases/sync_todos.dart';
import './features/todo/domain/usecases/update_todo.dart';
import './features/todo/domain/usecases/watch_todos.dart';
import './features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Todo
  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      createTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
      syncTodos: sl(),
      watchTodos: sl(),
      clearLocalData: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => SyncTodos(sl()));
  sl.registerLazySingleton(() => WatchTodos(sl()));
  sl.registerLazySingleton(() => ClearLocalData(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      syncManager: sl(),
      networkInfo: sl(),
      uuid: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(
    () => SyncManager(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(() => AppDatabase());

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const Uuid());

  // Data Sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sl()),
  );
}
