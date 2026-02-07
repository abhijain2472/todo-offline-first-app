import 'package:flutter/material.dart';
import '../../domain/repositories/locale_repository.dart';
import '../datasources/locale_local_data_source.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleLocalDataSource localDataSource;

  LocaleRepositoryImpl({required this.localDataSource});

  @override
  Future<Locale?> getSavedLocale() async {
    final localeCode = await localDataSource.getCachedLocale();
    if (localeCode == null) return null;
    return Locale(localeCode);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await localDataSource.cacheLocale(locale.languageCode);
  }
}
