import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './features/theme/presentation/bloc/theme_bloc.dart';
import './features/locale/presentation/bloc/locale_bloc.dart';
import './features/locale/presentation/bloc/locale_state.dart';
import './features/todo/presentation/pages/todo_list_screen.dart';
import './injection_container.dart' as di;
import './core/theme/app_theme.dart';
import './core/widgets/bloc_providers_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvidersContainer(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Todo App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                supportedLocales: AppLocalization.supportedLocals,
                localizationsDelegates: [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const TodoListScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
