import 'package:flutter/material.dart';
import '../../../../core/localization/app_localization.dart';
import '../pages/add_edit_todo_screen.dart';

class EmptyTodoView extends StatelessWidget {
  const EmptyTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl_rounded,
            size: 100,
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          Text(
            context.translations.home.noTodos,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translations.home.addFirstTodo,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditTodoScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(context.translations.home.addFirstTodoButton),
          ),
        ],
      ),
    );
  }
}
