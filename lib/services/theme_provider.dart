import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  double _azkarFontSize = 16.0;

  ThemeMode get themeMode => _themeMode;
  double get azkarFontSize => _azkarFontSize;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool('isLightMode') ?? false;
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    _azkarFontSize = prefs.getDouble('azkarFontSize') ?? 16.0;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightMode', mode == ThemeMode.light);
    notifyListeners();
  }

  void setAzkarFontSize(double size) async {
    _azkarFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('azkarFontSize', size);
    notifyListeners();
  }
}
