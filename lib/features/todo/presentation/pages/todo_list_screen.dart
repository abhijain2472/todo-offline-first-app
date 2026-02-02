import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import './add_edit_todo_screen.dart';
import '../widgets/todo_item_widget.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import '../../../../injection_container.dart';
import '../../../../core/database/app_database.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: () {
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
                      },
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<TodoBloc>().add(SyncTodosEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () {
              final db = sl<AppDatabase>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DriftDbViewer(db),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos yet. Add one!'));
            }
            return Column(
              children: [
                if (state.isSyncing)
                  const LinearProgressIndicator(), // Non-intrusive sync indicator
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<TodoBloc>().add(SyncTodosEvent());
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.todos.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
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
          } else if (state is TodoError) {
            // Even if error, we might have data in state if we persisted it?
            // Since TodoError replaces state, we lose list.
            // Ideally we should have check if we can show partial data.
            // But for now, simple error center.
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Start by adding a todo'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTodoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
