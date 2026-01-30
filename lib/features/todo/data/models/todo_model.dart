import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.syncId,
    required super.title,
    super.description = '',
    super.isCompleted = false,
    super.isDeleted = false,
    super.version = 1,
    required super.createdAt,
    required super.updatedAt,
    super.isSynced = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      syncId: json['syncId'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      version: json['version'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isSynced: true, // Data from server is always synced
    );
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      syncId: map['syncId'],
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: (map['isCompleted'] as int) == 1,
      isDeleted: (map['isDeleted'] as int) == 1,
      version: map['version'] as int,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: (map['isSynced'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'syncId': syncId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'syncId': syncId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  @override
  TodoModel copyWith({
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
    return TodoModel(
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
}
