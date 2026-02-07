// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes
// GENERATED FILE, do not edit!
import 'package:i69n/i69n.dart' as i69n;
import 'translations.i69n.dart';

String get _languageCode => 'gu';
String get _localeName => 'gu';

String _plural(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i69n.plural(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);
String _ordinal(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i69n.ordinal(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);
String _cardinal(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i69n.cardinal(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);

class Translations_gu extends Translations {
  const Translations_gu();
  String get appTitle => "ઑફલાઇન-ફર્સ્ટ ટૂડૂ એપ";
  CommonTranslations_gu get common => CommonTranslations_gu(this);
  HomeTranslations_gu get home => HomeTranslations_gu(this);
  TodoTranslations_gu get todo => TodoTranslations_gu(this);
  SettingsTranslations_gu get settings => SettingsTranslations_gu(this);
  AccessibilityTranslations_gu get accessibility =>
      AccessibilityTranslations_gu(this);
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'appTitle':
        return appTitle;
      case 'common':
        return common;
      case 'home':
        return home;
      case 'todo':
        return todo;
      case 'settings':
        return settings;
      case 'accessibility':
        return accessibility;
      default:
        return super[key];
    }
  }
}

class CommonTranslations_gu extends CommonTranslations {
  final Translations_gu _parent;
  const CommonTranslations_gu(this._parent) : super(_parent);
  String get cancel => "રદ કરો";
  String get retry => "ફરી પ્રયાસ કરો";
  String get error => "ભૂલ";
  String get save => "સાચવો";
  String get delete => "કાઢી નાખો";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'cancel':
        return cancel;
      case 'retry':
        return retry;
      case 'error':
        return error;
      case 'save':
        return save;
      case 'delete':
        return delete;
      default:
        return super[key];
    }
  }
}

class HomeTranslations_gu extends HomeTranslations {
  final Translations_gu _parent;
  const HomeTranslations_gu(this._parent) : super(_parent);
  String get searchPlaceholder => "ટૂડૂ શોધો...";
  String get filterAll => "બધા";
  String get filterActive => "સક્રિય";
  String get filterCompleted => "પૂર્ણ";
  String get noTodos => "હજુ સુધી કોઈ ટૂડૂ નથી";
  String get addFirstTodo => "શરૂ કરવા માટે એક કાર્ય ઉમેરો";
  String get addFirstTodoButton => "પ્રથમ ટૂડૂ ઉમેરો";
  String get errorLoading => "ટૂડૂ લોડ કરવામાં ભૂલ";
  String get errorTitle => "અરે!";
  String get tryAgain => "ફરી પ્રયાસ કરો";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'searchPlaceholder':
        return searchPlaceholder;
      case 'filterAll':
        return filterAll;
      case 'filterActive':
        return filterActive;
      case 'filterCompleted':
        return filterCompleted;
      case 'noTodos':
        return noTodos;
      case 'addFirstTodo':
        return addFirstTodo;
      case 'addFirstTodoButton':
        return addFirstTodoButton;
      case 'errorLoading':
        return errorLoading;
      case 'errorTitle':
        return errorTitle;
      case 'tryAgain':
        return tryAgain;
      default:
        return super[key];
    }
  }
}

class TodoTranslations_gu extends TodoTranslations {
  final Translations_gu _parent;
  const TodoTranslations_gu(this._parent) : super(_parent);
  String get addTitle => "ટૂડૂ ઉમેરો";
  String get editTitle => "ટૂડૂ સંપાદિત કરો";
  String get titleLabel => "શીર્ષક";
  String get titleHint => "શું કરવાનું છે?";
  String get titleRequired => "શીર્ષક જરૂરી છે";
  String get descriptionLabel => "વર્ણન";
  String get descriptionHint => "કેટલીક વિગતો ઉમેરો (વૈકલ્પિક)";
  String get saveButton => "ટૂડૂ સાચવો";
  String get saveChanges => "ફેરફારો સાચવો";
  String get createTodo => "ટૂડૂ બનાવો";
  String get synced => "સમન્વયિત";
  String get pendingSync => "સમન્વયન બાકી";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'addTitle':
        return addTitle;
      case 'editTitle':
        return editTitle;
      case 'titleLabel':
        return titleLabel;
      case 'titleHint':
        return titleHint;
      case 'titleRequired':
        return titleRequired;
      case 'descriptionLabel':
        return descriptionLabel;
      case 'descriptionHint':
        return descriptionHint;
      case 'saveButton':
        return saveButton;
      case 'saveChanges':
        return saveChanges;
      case 'createTodo':
        return createTodo;
      case 'synced':
        return synced;
      case 'pendingSync':
        return pendingSync;
      default:
        return super[key];
    }
  }
}

class SettingsTranslations_gu extends SettingsTranslations {
  final Translations_gu _parent;
  const SettingsTranslations_gu(this._parent) : super(_parent);
  String get title => "સેટિંગ્સ";
  String get darkMode => "ડાર્ક મોડ";
  String get language => "ભાષા";
  String get languageSubtitle => "તમારી પસંદીદા ભાષા પસંદ કરો";
  String get dataManagement => "ડેટા વ્યવસ્થાપન";
  String get syncNow => "હવે સમન્વયિત કરો";
  String get syncNowSubtitle => "રિમોટ સર્વર સાથે ફરજિયાત સમન્વયન કરો";
  String get clearData => "સ્થાનિક ડેટા સાફ કરો";
  String get clearDataSubtitle => "સ્થાનિક ડેટાબેઝમાંથી તમામ ટૂડૂ કાઢી નાખો";
  String get developer => "ડેવલપર વિકલ્પો";
  String get viewDatabase => "ડેટાબેઝ જુઓ";
  String get viewDatabaseSubtitle => "સ્થાનિક ડ્રિફ્ટ ડેટાબેઝનું નિરીક્ષણ કરો";
  String get clearDialogTitle => "સ્થાનિક ડેટા સાફ કરો?";
  String get clearDialogContent =>
      "આ તમારા સ્થાનિક ડેટાબેઝમાંથી તમામ ટૂડૂ કાઢી નાખશે. આ ખાલી સ્થિતિમાંથી સમન્વયન પરીક્ષણ માટે છે.";
  String get clearDialogConfirm => "સાફ કરો";
  String get dataCleared => "સ્થાનિક ડેટા સાફ કરાયો";
  String get syncStarted => "સમન્વયન શરૂ થયું...";
  String get languageEnglish => "English (અંગ્રેજી)";
  String get languageHindi => "हिन्दी (હિન્દી)";
  String get languageGujarati => "ગુજરાતી";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'title':
        return title;
      case 'darkMode':
        return darkMode;
      case 'language':
        return language;
      case 'languageSubtitle':
        return languageSubtitle;
      case 'dataManagement':
        return dataManagement;
      case 'syncNow':
        return syncNow;
      case 'syncNowSubtitle':
        return syncNowSubtitle;
      case 'clearData':
        return clearData;
      case 'clearDataSubtitle':
        return clearDataSubtitle;
      case 'developer':
        return developer;
      case 'viewDatabase':
        return viewDatabase;
      case 'viewDatabaseSubtitle':
        return viewDatabaseSubtitle;
      case 'clearDialogTitle':
        return clearDialogTitle;
      case 'clearDialogContent':
        return clearDialogContent;
      case 'clearDialogConfirm':
        return clearDialogConfirm;
      case 'dataCleared':
        return dataCleared;
      case 'syncStarted':
        return syncStarted;
      case 'languageEnglish':
        return languageEnglish;
      case 'languageHindi':
        return languageHindi;
      case 'languageGujarati':
        return languageGujarati;
      default:
        return super[key];
    }
  }
}

class AccessibilityTranslations_gu extends AccessibilityTranslations {
  final Translations_gu _parent;
  const AccessibilityTranslations_gu(this._parent) : super(_parent);
  String get switchToLight => "લાઇટ મોડ પર સ્વિચ કરો";
  String get switchToDark => "ડાર્ક મોડ પર સ્વિચ કરો";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)]
          as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'switchToLight':
        return switchToLight;
      case 'switchToDark':
        return switchToDark;
      default:
        return super[key];
    }
  }
}
