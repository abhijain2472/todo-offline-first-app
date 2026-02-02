import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/todo_repository.dart';

/// Use case for clearing all local todo data (DEBUG)
class ClearLocalData {
  final TodoRepository repository;

  ClearLocalData(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearLocalData();
  }
}
