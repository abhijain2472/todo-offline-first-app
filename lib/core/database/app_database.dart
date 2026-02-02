import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Todos table definition
@DataClassName('TodoTableData')
class Todos extends Table {
  TextColumn get syncId => text().withLength(min: 36, max: 36)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {syncId};
}

@DataClassName('SyncMetadataTableData')
class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

enum SyncAction { create, update, delete }

/// SyncOutbox table definition
@DataClassName('SyncOutboxTableData')
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get syncId => text()();
  TextColumn get action => textEnum<SyncAction>()();
  TextColumn get payload => text()(); // JSON string
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// AppDatabase class
@DriftDatabase(tables: [Todos, SyncMetadata, SyncOutbox])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

/// Database connection helper
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
