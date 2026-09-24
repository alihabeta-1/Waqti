import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void toggleTheme() {
    final themeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(state.copyWith(themeMode: themeMode));
  }

  void toggleLanguage() {
    final locale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');

    emit(state.copyWith(locale: locale));
  }

  void changeTheme(ThemeMode themeMode) {
    if (themeMode == state.themeMode) return;

    emit(state.copyWith(themeMode: themeMode));
  }

  void changeLanguage(Locale locale) {
    if (locale == state.locale) return;

    emit(state.copyWith(locale: locale));
  }
}
