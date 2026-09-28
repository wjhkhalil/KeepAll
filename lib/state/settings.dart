import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/money.dart';

/// Chosen at onboarding. Changes which cards the home screen shows and, for
/// [simple], the whole interface: larger text and buttons, higher contrast
/// and confirmation before deleting.
enum UserMode {
  student,
  everyday,
  simple;

  static UserMode fromName(String? name) =>
      UserMode.values.firstWhere((m) => m.name == name, orElse: () => UserMode.everyday);
}

/// The app's colour theme, picked under More → Appearance.
enum ColorPalette {
  deepOcean,
  matchaHoney,
  sunsetPop,
  midnightCandy,
  softPastel,
  creamCocoa,
  nordicSnow,
  skySunshine,
  lavenderNight,
  lemonCharcoal;

  static ColorPalette fromName(String? name) =>
      // Cream & Cocoa is the default for new users (owner's choice).
      ColorPalette.values.firstWhere((p) => p.name == name, orElse: () => ColorPalette.creamCocoa);
}

/// Languages the app is translated into.
const supportedLanguages = ['en', 'de', 'fr', 'es', 'it', 'nl', 'pl'];

class Settings extends ChangeNotifier {
  Settings(this._prefs);

  final SharedPreferences _prefs;

  static Future<Settings> load() async => Settings(await SharedPreferences.getInstance());

  static const _kOnboarded = 'onboarded';
  static const _kMode = 'mode';
  static const _kName = 'name';
  static const _kTheme = 'theme';
  static const _kCurrency = 'currency';
  static const _kLargeText = 'largeText';
  static const _kHighContrast = 'highContrast';
  static const _kConfirmDelete = 'confirmDelete';
  static const _kEmergencyName = 'emergencyName';
  static const _kEmergencyPhone = 'emergencyPhone';
  static const _kLanguage = 'language';
  static const _kPalette = 'palette';

  static const _stringKeys = [_kMode, _kName, _kTheme, _kCurrency, _kEmergencyName, _kEmergencyPhone, _kLanguage, _kPalette];
  static const _boolKeys = [_kOnboarded, _kLargeText, _kHighContrast, _kConfirmDelete];

  bool get onboarded => _prefs.getBool(_kOnboarded) ?? false;
  UserMode get mode => UserMode.fromName(_prefs.getString(_kMode));
  String get name => _prefs.getString(_kName) ?? '';
  ThemeMode get themeMode =>
      ThemeMode.values.firstWhere((t) => t.name == _prefs.getString(_kTheme), orElse: () => ThemeMode.system);
  Currency get currency => Currency.fromCode(_prefs.getString(_kCurrency));
  ColorPalette get palette => ColorPalette.fromName(_prefs.getString(_kPalette));

  /// Each accessibility option defaults to on in Simple mode, but the user
  /// can still override it.
  bool get largeText => _prefs.getBool(_kLargeText) ?? mode == UserMode.simple;
  bool get highContrast => _prefs.getBool(_kHighContrast) ?? mode == UserMode.simple;
  bool get confirmDelete => _prefs.getBool(_kConfirmDelete) ?? mode == UserMode.simple;

  String get emergencyName => _prefs.getString(_kEmergencyName) ?? '';
  String get emergencyPhone => _prefs.getString(_kEmergencyPhone) ?? '';
  bool get hasEmergencyContact => emergencyPhone.trim().isNotEmpty;

  /// Chosen language code, or null to follow the phone.
  String? get language {
    final v = _prefs.getString(_kLanguage);
    return supportedLanguages.contains(v) ? v : null;
  }

  /// The language actually used: the chosen one, else the phone's if we
  /// support it, else English.
  String effectiveLanguage(Locale deviceLocale) =>
      language ?? (supportedLanguages.contains(deviceLocale.languageCode) ? deviceLocale.languageCode : 'en');

  Future<void> setLanguage(String? code) =>
      _set(() => code == null ? _prefs.remove(_kLanguage) : _prefs.setString(_kLanguage, code));

  /// All settings, for backups.
  Map<String, dynamic> toJson() => {
    for (final k in _stringKeys)
      if (_prefs.getString(k) != null) k: _prefs.getString(k),
    for (final k in _boolKeys)
      if (_prefs.getBool(k) != null) k: _prefs.getBool(k),
  };

  /// Restores settings from a backup; unknown keys are ignored.
  Future<void> applyJson(Map<String, dynamic> json) async {
    for (final k in [..._stringKeys, ..._boolKeys]) {
      await _prefs.remove(k);
    }
    for (final k in _stringKeys) {
      if (json[k] is String) await _prefs.setString(k, json[k] as String);
    }
    for (final k in _boolKeys) {
      if (json[k] is bool) await _prefs.setBool(k, json[k] as bool);
    }
    // A restored backup always comes from a set-up app.
    await _prefs.setBool(_kOnboarded, true);
    notifyListeners();
  }

  /// Extra scale applied on top of the system text size.
  double get textScale => largeText ? 1.3 : 1.0;

  /// Larger tap targets for Simple mode / large text.
  bool get bigTargets => mode == UserMode.simple || largeText;

  Future<void> completeOnboarding({required UserMode mode, required String name, required Currency currency}) async {
    await _prefs.setString(_kMode, mode.name);
    await _prefs.setString(_kName, name.trim());
    await _prefs.setString(_kCurrency, currency.code);
    await _prefs.setBool(_kOnboarded, true);
    notifyListeners();
  }

  Future<void> setMode(UserMode v) async {
    await _prefs.setString(_kMode, v.name);
    // Let the new mode's accessibility defaults apply.
    await _prefs.remove(_kLargeText);
    await _prefs.remove(_kHighContrast);
    await _prefs.remove(_kConfirmDelete);
    notifyListeners();
  }

  Future<void> setName(String v) => _set(() => _prefs.setString(_kName, v.trim()));
  Future<void> setThemeMode(ThemeMode v) => _set(() => _prefs.setString(_kTheme, v.name));
  Future<void> setPalette(ColorPalette v) => _set(() => _prefs.setString(_kPalette, v.name));
  Future<void> setCurrency(Currency v) => _set(() => _prefs.setString(_kCurrency, v.code));
  Future<void> setLargeText(bool v) => _set(() => _prefs.setBool(_kLargeText, v));
  Future<void> setHighContrast(bool v) => _set(() => _prefs.setBool(_kHighContrast, v));
  Future<void> setConfirmDelete(bool v) => _set(() => _prefs.setBool(_kConfirmDelete, v));

  Future<void> setEmergencyContact(String name, String phone) => _set(() async {
    await _prefs.setString(_kEmergencyName, name.trim());
    await _prefs.setString(_kEmergencyPhone, phone.trim());
    return true;
  });

  Future<void> _set(Future<bool> Function() write) async {
    await write();
    notifyListeners();
  }
}
