import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import './add_edit_todo_screen.dart';
import '../widgets/todo_item_widget.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<TodoBloc>().add(SyncTodosEvent());
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
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        return TodoItemWidget(
                          todo: state.todos[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditTodoScreen(
                                  todo: state.todos[index],
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
