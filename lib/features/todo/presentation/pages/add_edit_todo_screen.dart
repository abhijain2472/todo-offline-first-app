import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localization.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo; // If null, it's Add mode. If provided, it's Edit mode.

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (widget.todo == null) {
        // Add
        context.read<TodoBloc>().add(AddTodoEvent(
              title: title,
              description: description,
            ));
      } else {
        // Edit
        final updatedTodo = widget.todo!.copyWith(
          title: title,
          description: description,
        );
        context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing
              ? context.translations.todo.editTitle
              : context.translations.todo.addTitle),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    labelText: context.translations.todo.titleLabel,
                    hintText: context.translations.todo.titleHint,
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.translations.todo.titleRequired;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  autofocus: !isEditing,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.done,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: context.translations.todo.descriptionLabel,
                    hintText: context.translations.todo.descriptionHint,
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 5,
                  minLines: 3,
                  onFieldSubmitted: (_) => _saveTodo(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _saveTodo,
                    icon: Icon(isEditing ? Icons.save : Icons.add),
                    label: Text(
                      isEditing
                          ? context.translations.todo.saveChanges
                          : context.translations.todo.createTodo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
