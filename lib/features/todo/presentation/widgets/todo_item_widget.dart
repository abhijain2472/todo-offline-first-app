import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Dismissible(
      key: Key(todo.syncId),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<TodoBloc>().add(DeleteTodoEvent(todo.syncId));
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: todo.isCompleted,
              shape: const CircleBorder(),
              onChanged: (value) {
                context.read<TodoBloc>().add(ToggleTodoCompletionEvent(todo));
              },
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: todo.description.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    todo.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: todo.isCompleted ? Colors.grey : Colors.black54,
                    ),
                  ),
                )
              : null,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              todo.isSynced
                  ? const Icon(Icons.cloud_done, color: Colors.green, size: 20)
                  : const Icon(Icons.cloud_upload,
                      color: Colors.orange, size: 20),
              const SizedBox(height: 4),
              Text(
                todo.isSynced ? 'Synced' : 'Local',
                style: TextStyle(
                  fontSize: 10,
                  color: todo.isSynced ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
