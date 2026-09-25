import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waqti/app/cubit/app_state.dart';
import 'package:waqti/app/data/app_preferences.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required AppPreferences preferences})
    : _preferences = preferences,
      super(
        AppState(
          themeMode: preferences.getThemeMode(),
          locale: preferences.getLocale(),
        ),
      );

  final AppPreferences _preferences;

  Future<void> toggleTheme() async {
    final themeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(state.copyWith(themeMode: themeMode));

    await _preferences.saveThemeMode(themeMode);
  }

  Future<void> toggleLanguage() async {
    final locale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');

    emit(state.copyWith(locale: locale));

    await _preferences.saveLocale(locale);
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) {
      return;
    }

    emit(state.copyWith(themeMode: themeMode));

    await _preferences.saveThemeMode(themeMode);
  }

  Future<void> changeLanguage(Locale locale) async {
    if (locale == state.locale) {
      return;
    }

    emit(state.copyWith(locale: locale));

    await _preferences.saveLocale(locale);
  }
}
