import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleLocalDataSource {
  /// Gets the cached locale code
  /// Returns null if no locale is cached
  Future<String?> getCachedLocale();

  /// Caches the locale code
  Future<void> cacheLocale(String localeCode);
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  static const String _localeKey = 'CACHED_LOCALE';
  final SharedPreferences sharedPreferences;

  LocaleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getCachedLocale() async {
    return sharedPreferences.getString(_localeKey);
  }

  @override
  Future<void> cacheLocale(String localeCode) async {
    await sharedPreferences.setString(_localeKey, localeCode);
  }
}
