import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for watching todos real-time
class WatchTodos {
  final TodoRepository repository;

  WatchTodos(this.repository);

  Stream<List<Todo>> call() {
    return repository.watchTodos();
  }
}
