import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<void> cacheThemeMode(ThemeMode mode);
  Future<ThemeMode> getCachedThemeMode();
}

const String cachedThemeKey = 'CACHED_THEME_MODE';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheThemeMode(ThemeMode mode) async {
    await sharedPreferences.setString(cachedThemeKey, mode.toString());
  }

  @override
  Future<ThemeMode> getCachedThemeMode() async {
    final themeString = sharedPreferences.getString(cachedThemeKey);
    if (themeString != null) {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      return ThemeMode.system;
    }
  }
}
