import 'package:flutter/material.dart';
import '../datasources/theme_local_data_source.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<ThemeMode> getThemeMode() async {
    return await localDataSource.getCachedThemeMode();
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await localDataSource.cacheThemeMode(mode);
  }
}
