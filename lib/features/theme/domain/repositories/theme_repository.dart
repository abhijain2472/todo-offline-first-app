import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<void> setThemeMode(ThemeMode mode);
  Future<ThemeMode> getThemeMode();
}
