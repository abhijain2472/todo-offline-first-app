// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes
// GENERATED FILE, do not edit!
import 'package:i69n/i69n.dart' as i69n;
import 'translations.i69n.dart';

String get _languageCode => 'hi';
String get _localeName => 'hi';

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

class Translations_hi extends Translations {
  const Translations_hi();
  String get appTitle => "ऑफ़लाइन-फर्स्ट टूडू ऐप";
  CommonTranslations_hi get common => CommonTranslations_hi(this);
  HomeTranslations_hi get home => HomeTranslations_hi(this);
  TodoTranslations_hi get todo => TodoTranslations_hi(this);
  SettingsTranslations_hi get settings => SettingsTranslations_hi(this);
  AccessibilityTranslations_hi get accessibility =>
      AccessibilityTranslations_hi(this);
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

class CommonTranslations_hi extends CommonTranslations {
  final Translations_hi _parent;
  const CommonTranslations_hi(this._parent) : super(_parent);
  String get cancel => "रद्द करें";
  String get retry => "पुनः प्रयास करें";
  String get error => "त्रुटि";
  String get save => "सहेजें";
  String get delete => "हटाएं";
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

class HomeTranslations_hi extends HomeTranslations {
  final Translations_hi _parent;
  const HomeTranslations_hi(this._parent) : super(_parent);
  String get searchPlaceholder => "टूडू खोजें...";
  String get filterAll => "सभी";
  String get filterActive => "सक्रिय";
  String get filterCompleted => "पूर्ण";
  String get noTodos => "अभी तक कोई टूडू नहीं";
  String get addFirstTodo => "शुरू करने के लिए एक कार्य जोड़ें";
  String get addFirstTodoButton => "पहला टूडू जोड़ें";
  String get errorLoading => "टूडू लोड करने में त्रुटि";
  String get errorTitle => "उफ़!";
  String get tryAgain => "पुनः प्रयास करें";
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

class TodoTranslations_hi extends TodoTranslations {
  final Translations_hi _parent;
  const TodoTranslations_hi(this._parent) : super(_parent);
  String get addTitle => "टूडू जोड़ें";
  String get editTitle => "टूडू संपादित करें";
  String get titleLabel => "शीर्षक";
  String get titleHint => "क्या करना है?";
  String get titleRequired => "शीर्षक आवश्यक है";
  String get descriptionLabel => "विवरण";
  String get descriptionHint => "कुछ विवरण जोड़ें (वैकल्पिक)";
  String get saveButton => "टूडू सहेजें";
  String get saveChanges => "परिवर्तन सहेजें";
  String get createTodo => "टूडू बनाएं";
  String get synced => "समन्वयित";
  String get pendingSync => "समन्वयन लंबित";
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

class SettingsTranslations_hi extends SettingsTranslations {
  final Translations_hi _parent;
  const SettingsTranslations_hi(this._parent) : super(_parent);
  String get title => "सेटिंग्स";
  String get darkMode => "डार्क मोड";
  String get language => "भाषा";
  String get languageSubtitle => "अपनी पसंदीदा भाषा चुनें";
  String get dataManagement => "डेटा प्रबंधन";
  String get syncNow => "अभी समन्वयित करें";
  String get syncNowSubtitle => "रिमोट सर्वर के साथ जबरन समन्वयन करें";
  String get clearData => "स्थानीय डेटा साफ़ करें";
  String get clearDataSubtitle => "स्थानीय डेटाबेस से सभी टूडू हटाएं";
  String get developer => "डेवलपर विकल्प";
  String get viewDatabase => "डेटाबेस देखें";
  String get viewDatabaseSubtitle => "स्थानीय ड्रिफ्ट डेटाबेस का निरीक्षण करें";
  String get clearDialogTitle => "स्थानीय डेटा साफ़ करें?";
  String get clearDialogContent =>
      "यह आपके स्थानीय डेटाबेस से सभी टूडू हटा देगा। यह खाली स्थिति से समन्वयन परीक्षण के लिए है।";
  String get clearDialogConfirm => "साफ़ करें";
  String get dataCleared => "स्थानीय डेटा साफ़ किया गया";
  String get syncStarted => "समन्वयन शुरू हो गया...";
  String get languageEnglish => "English (अंग्रेज़ी)";
  String get languageHindi => "हिन्दी";
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
      default:
        return super[key];
    }
  }
}

class AccessibilityTranslations_hi extends AccessibilityTranslations {
  final Translations_hi _parent;
  const AccessibilityTranslations_hi(this._parent) : super(_parent);
  String get switchToLight => "लाइट मोड पर स्विच करें";
  String get switchToDark => "डार्क मोड पर स्विच करें";
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
