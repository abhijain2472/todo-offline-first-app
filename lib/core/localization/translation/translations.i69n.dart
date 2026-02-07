// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes
// GENERATED FILE, do not edit!
import 'package:i69n/i69n.dart' as i69n;

String get _languageCode => 'en';
String get _localeName => 'en';

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

class Translations implements i69n.I69nMessageBundle {
  const Translations();
  String get appTitle => "Offline-First Todo App";
  CommonTranslations get common => CommonTranslations(this);
  HomeTranslations get home => HomeTranslations(this);
  TodoTranslations get todo => TodoTranslations(this);
  SettingsTranslations get settings => SettingsTranslations(this);
  AccessibilityTranslations get accessibility =>
      AccessibilityTranslations(this);
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
        return key;
    }
  }
}

class CommonTranslations implements i69n.I69nMessageBundle {
  final Translations _parent;
  const CommonTranslations(this._parent);
  String get cancel => "Cancel";
  String get retry => "Retry";
  String get error => "Error";
  String get save => "Save";
  String get delete => "Delete";
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
        return key;
    }
  }
}

class HomeTranslations implements i69n.I69nMessageBundle {
  final Translations _parent;
  const HomeTranslations(this._parent);
  String get searchPlaceholder => "Search todos...";
  String get filterAll => "All";
  String get filterActive => "Active";
  String get filterCompleted => "Completed";
  String get noTodos => "No todos yet";
  String get addFirstTodo => "Add a task to get started";
  String get addFirstTodoButton => "Add First Todo";
  String get errorLoading => "Error loading todos";
  String get errorTitle => "Oops!";
  String get tryAgain => "Try Again";
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
        return key;
    }
  }
}

class TodoTranslations implements i69n.I69nMessageBundle {
  final Translations _parent;
  const TodoTranslations(this._parent);
  String get addTitle => "Add Todo";
  String get editTitle => "Edit Todo";
  String get titleLabel => "Title";
  String get titleHint => "What needs to be done?";
  String get titleRequired => "Title is required";
  String get descriptionLabel => "Description";
  String get descriptionHint => "Add some details (optional)";
  String get saveButton => "Save Todo";
  String get saveChanges => "Save Changes";
  String get createTodo => "Create Todo";
  String get synced => "Synced";
  String get pendingSync => "Pending Sync";
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
        return key;
    }
  }
}

class SettingsTranslations implements i69n.I69nMessageBundle {
  final Translations _parent;
  const SettingsTranslations(this._parent);
  String get title => "Settings";
  String get darkMode => "Dark Mode";
  String get language => "Language";
  String get languageSubtitle => "Choose your preferred language";
  String get dataManagement => "Data Management";
  String get syncNow => "Sync Now";
  String get syncNowSubtitle => "Force sync with remote server";
  String get clearData => "Clear Local Data";
  String get clearDataSubtitle => "Delete all todos from local database";
  String get developer => "Developer Options";
  String get viewDatabase => "View Database";
  String get viewDatabaseSubtitle => "Inspect local Drift database";
  String get clearDialogTitle => "Clear Local Data?";
  String get clearDialogContent =>
      "This will delete all todos from your local database. It is for testing sync from empty state.";
  String get clearDialogConfirm => "Clear";
  String get dataCleared => "Local data cleared";
  String get syncStarted => "Sync started...";
  String get languageEnglish => "English";
  String get languageHindi => "हिन्दी (Hindi)";
  String get languageGujarati => "ગુજરાતી (Gujarati)";
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
        return key;
    }
  }
}

class AccessibilityTranslations implements i69n.I69nMessageBundle {
  final Translations _parent;
  const AccessibilityTranslations(this._parent);
  String get switchToLight => "Switch to Light Mode";
  String get switchToDark => "Switch to Dark Mode";
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
        return key;
    }
  }
}
