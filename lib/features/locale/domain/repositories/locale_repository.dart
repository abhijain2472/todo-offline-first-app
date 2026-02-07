import 'package:flutter/material.dart';

abstract class LocaleRepository {
  /// Gets the saved locale
  Future<Locale?> getSavedLocale();

  /// Saves the selected locale
  Future<void> saveLocale(Locale locale);
}
