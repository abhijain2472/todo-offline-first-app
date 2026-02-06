import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/todo/presentation/bloc/todo_bloc.dart';
import './features/todo/presentation/bloc/todo_event.dart';
import './features/theme/presentation/bloc/theme_bloc.dart';
import './features/todo/presentation/pages/todo_list_screen.dart';
import './injection_container.dart' as di;
import './core/theme/app_theme.dart';

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
        BlocProvider(
          create: (_) => di.sl<ThemeBloc>()..add(LoadThemeEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Offline-First Todo App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const TodoListScreen(),
          );
        },
      ),
    );
  }
}
