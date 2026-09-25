import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  ThemeMode getThemeMode() {
    final savedTheme = _sharedPreferences.getString(_themeKey);

    return savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Locale getLocale() {
    final savedLanguage = _sharedPreferences.getString(_languageKey);

    return Locale(savedLanguage == 'ar' ? 'ar' : 'en');
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setString(
      _themeKey,
      themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> saveLocale(Locale locale) async {
    await _sharedPreferences.setString(_languageKey, locale.languageCode);
  }
}
