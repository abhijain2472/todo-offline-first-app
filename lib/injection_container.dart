import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'core/database/app_database.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'core/network/network_client.dart';
import 'core/network/http_network_client.dart';
import 'core/constants/constants.dart';
import 'core/sync/sync_manager.dart';

import 'features/todo/data/datasources/todo_local_data_source.dart';
import 'features/todo/data/datasources/todo_local_data_source_impl.dart';
import 'features/todo/data/datasources/todo_remote_data_source.dart';
import 'features/todo/data/datasources/todo_remote_data_source_impl.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/clear_local_data.dart';
import 'features/todo/domain/usecases/create_todo.dart';
import 'features/todo/domain/usecases/delete_todo.dart';
import 'features/todo/domain/usecases/get_todos.dart';
import 'features/todo/domain/usecases/sync_todos.dart';
import 'features/todo/domain/usecases/update_todo.dart';
import 'features/todo/domain/usecases/watch_todos.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';

import 'features/theme/data/datasources/theme_local_data_source.dart';
import 'features/theme/data/repositories/theme_repository_impl.dart';
import 'features/theme/domain/repositories/theme_repository.dart';
import 'features/theme/presentation/bloc/theme_bloc.dart';

import 'features/locale/data/datasources/locale_local_data_source.dart';
import 'features/locale/data/repositories/locale_repository_impl.dart';
import 'features/locale/domain/repositories/locale_repository.dart';
import 'features/locale/presentation/bloc/locale_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Theme
  // Bloc
  sl.registerFactory(
    () => ThemeBloc(themeRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Locale
  // Bloc
  sl.registerFactory(
    () => LocaleBloc(localeRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocaleLocalDataSource>(
    () => LocaleLocalDataSourceImpl(sharedPreferences: sl()),
  );

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

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(client: sl()),
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

  sl.registerLazySingleton<NetworkClient>(
    () => HttpNetworkClient(
      client: sl(),
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => const Uuid());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
