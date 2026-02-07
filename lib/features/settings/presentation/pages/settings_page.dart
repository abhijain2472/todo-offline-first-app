import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import '../../../../injection_container.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../theme/presentation/bloc/theme_bloc.dart';
import '../../../locale/presentation/bloc/locale_bloc.dart';
import '../../../locale/presentation/bloc/locale_event.dart';
import '../../../locale/presentation/bloc/locale_state.dart';
import '../../../todo/presentation/bloc/todo_bloc.dart';
import '../../../todo/presentation/bloc/todo_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translations.settings.title),
      ),
      body: ListView(
        children: [
          const _ThemeSection(),
          const Divider(),
          const _LanguageSection(),
          const Divider(),
          const _DataSection(),
          const Divider(),
          const _DeveloperSection(),
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return ListTile(
          leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          title: Text(context.translations.settings.darkMode),
          trailing: Switch(
            value: isDark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
        );
      },
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.translations.settings.language),
          subtitle: Text(context.translations.settings.languageSubtitle),
          trailing: DropdownButton<Locale>(
            value: state.locale,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: const Locale('en'),
                child: Text(context.translations.settings.languageEnglish),
              ),
              DropdownMenuItem(
                value: const Locale('hi'),
                child: Text(context.translations.settings.languageHindi),
              ),
            ],
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                context.read<LocaleBloc>().add(ChangeLocaleEvent(newLocale));
              }
            },
          ),
        );
      },
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            context.translations.settings.dataManagement,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: Text(context.translations.settings.syncNow),
          subtitle: Text(context.translations.settings.syncNowSubtitle),
          onTap: () {
            context.read<TodoBloc>().add(SyncTodosEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.translations.settings.syncStarted)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: Text(context.translations.settings.clearData,
              style: const TextStyle(color: Colors.red)),
          subtitle: Text(context.translations.settings.clearDataSubtitle),
          onTap: () => _showClearDataDialog(context),
        ),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.translations.settings.clearDialogTitle),
        content: Text(context.translations.settings.clearDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.translations.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoBloc>().add(ClearLocalDataEvent());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(context.translations.settings.dataCleared)),
              );
            },
            child: Text(context.translations.settings.clearDialogConfirm,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DeveloperSection extends StatelessWidget {
  const _DeveloperSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            context.translations.settings.developer,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: Text(context.translations.settings.viewDatabase),
          subtitle: Text(context.translations.settings.viewDatabaseSubtitle),
          onTap: () {
            final db = sl<AppDatabase>();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DriftDbViewer(db),
              ),
            );
          },
        ),
      ],
    );
  }
}
