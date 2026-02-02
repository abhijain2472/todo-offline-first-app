import 'package:equatable/equatable.dart';
import './todo_model.dart';

class SyncResponseModel extends Equatable {
  final String timestamp;
  final List<TodoModel> changes;

  const SyncResponseModel({
    required this.timestamp,
    required this.changes,
  });

  factory SyncResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncResponseModel(
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      changes: (json['changes'] as List?)
              ?.map((e) => TodoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [timestamp, changes];
}
