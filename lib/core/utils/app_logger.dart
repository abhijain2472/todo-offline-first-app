import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// AppLogger - Comprehensive logging utility for tracking all app operations
///
/// Features:
/// - Color-coded console logs with emojis
/// - Timestamps for all logs
/// - Categorized logging (DB, API, SYNC, BLOC, etc.)
/// - Detailed action tracking
class AppLogger {
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');

  // ANSI color codes for terminal
  static const String _reset = '\x1B[0m';
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';

  /// Log general information
  static void info(String message, {String? category}) {
    _log('ℹ️', _cyan, category ?? 'INFO', message);
  }

  /// Log success messages
  static void success(String message, {String? category}) {
    _log('✅', _green, category ?? 'SUCCESS', message);
  }

  /// Log warnings
  static void warning(String message, {String? category}) {
    _log('⚠️', _yellow, category ?? 'WARNING', message);
  }

  /// Log errors
  static void error(String message, {String? category, dynamic error}) {
    final errorMsg = error != null ? '$message: $error' : message;
    _log('❌', _red, category ?? 'ERROR', errorMsg);
  }

  /// Log database operations
  static void database(String action, String details) {
    _log('🗄️', _blue, 'DB', '$action: $details');
  }

  /// Log API calls
  static void api(String endpoint, String method,
      {dynamic data, int? statusCode}) {
    final dataStr = data != null ? ' → Data: $data' : '';
    final statusStr = statusCode != null ? ' ($statusCode)' : '';
    _log('🌐', _green, 'API', '$method $endpoint$statusStr$dataStr');
  }

  /// Log sync operations
  static void sync(String action, String details) {
    _log('🔄', _yellow, 'SYNC', '$action: $details');
  }

  /// Log BLoC events and state changes
  static void bloc(String event, String state) {
    _log('📦', _magenta, 'BLOC', '$event → $state');
  }

  /// Internal logging method
  static void _log(
      String emoji, String color, String category, String message) {
    if (kDebugMode) {
      final timestamp = _timeFormat.format(DateTime.now());
      final categoryPadded = category;

      // Format: [HH:mm:ss.SSS] 🔄 [CATEGORY] Message
      debugPrint('$color[$timestamp] $emoji [$categoryPadded]$_reset $message');
    }
  }

  /// Log a separator line for visual clarity
  static void separator() {
    if (kDebugMode) {
      debugPrint('$_cyan${'═' * 80}$_reset');
    }
  }

  /// Log section header
  static void header(String title) {
    if (kDebugMode) {
      separator();
      debugPrint('$_cyan  $title$_reset');
      separator();
    }
  }
}
