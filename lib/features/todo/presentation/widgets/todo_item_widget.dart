import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localization.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onTap;

  const TodoItemWidget({
    super.key,
    required this.todo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(todo.syncId),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<TodoBloc>().add(DeleteTodoEvent(todo.syncId));
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: todo.isCompleted
                ? Colors.transparent
                : colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        color: todo.isCompleted
            ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
            : colorScheme.surface,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      context
                          .read<TodoBloc>()
                          .add(ToggleTodoCompletionEvent(todo));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    activeColor: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? theme.textTheme.bodyMedium?.color
                              : theme.textTheme.titleMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (todo.isSynced)
                  Tooltip(
                    message: context.translations.todo.synced,
                    child: Icon(
                      Icons.cloud_done,
                      size: 16,
                      color: colorScheme.secondary,
                    ),
                  )
                else
                  Tooltip(
                    message: context.translations.todo.pendingSync,
                    child: Icon(
                      Icons.cloud_upload,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
