// lib/core/services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyAutoCheckUpdate = 'auto_check_update';

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? true;
  }

  static Future<void> setAutoCheckUpdate(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoCheckUpdate, value);
  }

  static Future<bool> getAutoCheckUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoCheckUpdate) ?? true;
  }
}
