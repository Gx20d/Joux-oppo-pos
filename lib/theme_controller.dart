import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._();

  ThemeController._();

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool("dark_mode") ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDark = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", value);

    notifyListeners();
  }
}