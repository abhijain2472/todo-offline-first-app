import 'package:equatable/equatable.dart';

/// Todo entity - Core business object
///
/// This entity represents a Todo in the domain layer.
/// It contains all the properties that define a Todo in our business logic.
class Todo extends Equatable {
  final String syncId; // Client-generated UUID (primary identifier)
  final String title;
  final String description;
  final bool isCompleted;
  final bool isDeleted; // Soft delete flag
  final int version; // For conflict resolution
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced; // Local-only flag: track if synced with server

  const Todo({
    required this.syncId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.isDeleted = false,
    this.version = 1,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  /// Create a copy of this Todo with some fields replaced
  Todo copyWith({
    String? syncId,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isDeleted,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Todo(
      syncId: syncId ?? this.syncId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [
        syncId,
        title,
        description,
        isCompleted,
        isDeleted,
        version,
        createdAt,
        updatedAt,
        isSynced,
      ];

  @override
  String toString() {
    return 'Todo(syncId: $syncId, title: $title, isCompleted: $isCompleted, isSynced: $isSynced)';
  }
}
