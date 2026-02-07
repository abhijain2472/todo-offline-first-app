import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/todo/presentation/bloc/todo_bloc.dart';
import '../../features/todo/presentation/bloc/todo_event.dart';
import '../../features/theme/presentation/bloc/theme_bloc.dart';
import '../../features/locale/presentation/bloc/locale_bloc.dart';
import '../../features/locale/presentation/bloc/locale_event.dart';
import '../../injection_container.dart' as di;

/// Container widget that provides all BLoC instances to the widget tree
class BlocProvidersContainer extends StatelessWidget {
  final Widget child;

  const BlocProvidersContainer({
    super.key,
    required this.child,
  });

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
        BlocProvider(
          create: (_) => di.sl<LocaleBloc>()..add(LoadLocaleEvent()),
        ),
      ],
      child: child,
    );
  }
}
