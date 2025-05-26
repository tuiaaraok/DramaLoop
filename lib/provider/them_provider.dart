import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  // Инициализация Hive box
  Box? settingsBox;

  // Используем late для отложенной инициализации переменной
  late bool _isDarkMode;

  ThemeProvider(this.settingsBox) {
    // Загружаем значение из Hive
    _isDarkMode = settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    settingsBox?.put('isDarkMode', _isDarkMode); // Сохраняем значение в Hive
    notifyListeners();
  }

  Color get backgroundColor =>
      _isDarkMode ? Colors.black : const Color(0xFFF5FAFF);

  Color get iconColor => _isDarkMode ? Colors.white : Colors.black;

  Color get containerColor =>
      _isDarkMode ? const Color(0xFF5F61F3) : const Color(0xFF4749F1);
  Color get textContainerColor => _isDarkMode ? Colors.black : Colors.white;
  Color get titleColor => _isDarkMode ? Colors.white : Colors.black;
  Color get switchLightColor =>
      _isDarkMode ? const Color.fromARGB(255, 189, 189, 189) : Colors.black;
  Color get switchDarkColor =>
      _isDarkMode ? Colors.white : const Color(0xFF414141);
  Color get strokeColorDec =>
      _isDarkMode ? const Color(0xFF31343B) : const Color(0xFFDAE0E6);
}
