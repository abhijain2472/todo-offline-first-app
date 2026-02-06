import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import '../../../../injection_container.dart';
import '../../../../core/database/app_database.dart';
import '../../../theme/presentation/bloc/theme_bloc.dart';
import '../../../todo/presentation/bloc/todo_bloc.dart';
import '../../../todo/presentation/bloc/todo_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          _ThemeSection(),
          Divider(),
          _DataSection(),
          Divider(),
          _DeveloperSection(),
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
          title: const Text('Dark Mode'),
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

class _DataSection extends StatelessWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Data Management',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sync Now'),
          subtitle: const Text('Force sync with remote server'),
          onTap: () {
            context.read<TodoBloc>().add(SyncTodosEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sync started...')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Clear Local Data',
              style: TextStyle(color: Colors.red)),
          subtitle: const Text('Delete all todos from local database'),
          onTap: () => _showClearDataDialog(context),
        ),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Local Data?'),
        content: const Text(
            'This will delete all todos from your local database. It is for testing sync from empty state.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoBloc>().add(ClearLocalDataEvent());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local data cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Developer Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('View Database'),
          subtitle: const Text('Inspect local Drift database'),
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
