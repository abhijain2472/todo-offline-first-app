import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import './add_edit_todo_screen.dart';
import '../widgets/loading_todo_view.dart';
import '../widgets/error_todo_view.dart';
import '../widgets/loaded_todo_view.dart';
import '../widgets/todo_list_app_bar.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoListAppBar(),
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
            return const LoadingTodoView();
          } else if (state is TodoLoaded) {
            return LoadedTodoView(
              todos: state.todos,
              isSyncing: state.isSyncing,
            );
          } else if (state is TodoError) {
            return ErrorTodoView(
              message: state.message,
              onRetry: () {
                context.read<TodoBloc>().add(SyncTodosEvent());
              },
            );
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
