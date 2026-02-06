import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../pages/add_edit_todo_screen.dart';
import 'todo_item_widget.dart';
import 'empty_todo_view.dart';

class LoadedTodoView extends StatelessWidget {
  final List<Todo> todos;
  final bool isSyncing;

  const LoadedTodoView({
    super.key,
    required this.todos,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const EmptyTodoView();
    }
    return Column(
      children: [
        if (isSyncing)
          const LinearProgressIndicator(), // Non-intrusive sync indicator
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<TodoBloc>().add(SyncTodosEvent());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: todos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoItemWidget(
                  key: ValueKey(todo.syncId),
                  todo: todo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTodoScreen(
                          todo: todo,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
