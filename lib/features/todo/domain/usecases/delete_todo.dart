import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/todo_repository.dart';

/// Use case for deleting a todo (soft delete)
class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<Either<Failure, void>> call(String syncId) async {
    if (syncId.trim().isEmpty) {
      return const Left(ValidationFailure('Todo ID cannot be empty'));
    }

    return await repository.deleteTodo(syncId);
  }
}
