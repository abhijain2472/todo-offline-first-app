/// API Constants
class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.1.6:3000/api';

  // Endpoints
  static const String todos = '/todos';
  static const String sync = '/todos/sync';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// Database Constants
class DatabaseConstants {
  static const String databaseName = 'todo_app.db';
  static const int databaseVersion = 1;

  // Table names
  static const String todosTable = 'todos';
  static const String syncMetadataTable = 'sync_metadata';

  // Sync metadata keys
  static const String lastSyncTimeKey = 'last_sync_time';
}

/// App Constants
class AppConstants {
  static const String appName = 'Todo App';

  // Sync settings
  static const Duration syncInterval = Duration(minutes: 5);
  static const int maxSyncRetries = 3;
}
