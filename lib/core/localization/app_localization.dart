import 'package:flutter/material.dart';
import 'package:todo_offline_first_app/core/localization/translation/translations.i69n.dart';
import 'package:todo_offline_first_app/core/localization/translation/translations_hi.i69n.dart';
import 'package:todo_offline_first_app/core/localization/translation/translations_gu.i69n.dart';

export 'translation/translations.i69n.dart';

final _translations = <String, Translations Function()>{
  'en': () => const Translations(),
  'hi': () => const Translations_hi(),
  'gu': () => const Translations_gu(),
};

/// Extension to get language name from translations for each locale code
extension LocaleHelpers on BuildContext {
  String getLanguageDisplayName(String localeCode) {
    final translations = this.translations;
    switch (localeCode) {
      case 'en':
        return translations.settings.languageEnglish;
      case 'hi':
        return translations.settings.languageHindi;
      case 'gu':
        return translations.settings.languageGujarati;
      default:
        return localeCode.toUpperCase();
    }
  }
}

class AppLocalization {
  final Translations translations;

  AppLocalization(this.translations);

  static final List<Locale> supportedLocals =
      _translations.keys.map((e) => Locale(e)).toList();

  static final LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  static AppLocalization of(BuildContext context) =>
      Localizations.of<AppLocalization>(context, AppLocalization)!;
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) =>
      _translations.keys.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) =>
      Future.value(AppLocalization(_translations[locale.languageCode]!()));
  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}

extension AppLocalizationExtenstion on BuildContext {
  Translations get translations => AppLocalization.of(this).translations;
}
