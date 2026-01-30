import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/todo/presentation/bloc/todo_bloc.dart';
import './features/todo/presentation/bloc/todo_event.dart';
import './features/todo/presentation/pages/todo_list_screen.dart';
import './injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<TodoBloc>()..add(LoadTodosEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Offline-First Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        home: const TodoListScreen(),
      ),
    );
  }
}
