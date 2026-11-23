// lib/core/services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyIsFirstRun = 'is_first_run';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyAutoCheckUpdate = 'auto_check_update';

  static const String _keyUpupaEnabled = 'upupa_source_enabled';
  static const String _keyUpupaServerUrl = 'upupa_server_url';
  static const String _keyUpupaCollection = 'upupa_collection_name';

  static const String defaultUpupaCollection = 'packages';

  static Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFirstRun) ?? true;
  }

  static Future<void> setFirstRunCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstRun, false);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? true;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  static Future<bool> getAutoCheckUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoCheckUpdate) ?? true;
  }

  static Future<void> setAutoCheckUpdate(bool autoCheck) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoCheckUpdate, autoCheck);
  }

  static Future<bool> isUpupaSourceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUpupaEnabled) ?? true;
  }

  static Future<void> setUpupaSourceEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUpupaEnabled, enabled);
  }

  static Future<String?> getUpupaServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyUpupaServerUrl)?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<void> setUpupaServerUrl(String? url) async {
    final prefs = await SharedPreferences.getInstance();
    final cleaned = url?.trim() ?? '';
    if (cleaned.isEmpty) {
      await prefs.remove(_keyUpupaServerUrl);
    } else {
      await prefs.setString(_keyUpupaServerUrl, cleaned);
    }
  }

  static Future<String> getUpupaCollectionName() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyUpupaCollection)?.trim();
    if (value == null || value.isEmpty) return defaultUpupaCollection;
    return value;
  }

  static Future<void> setUpupaCollectionName(String? collection) async {
    final prefs = await SharedPreferences.getInstance();
    final cleaned = collection?.trim() ?? '';
    if (cleaned.isEmpty || cleaned == defaultUpupaCollection) {
      await prefs.remove(_keyUpupaCollection);
    } else {
      await prefs.setString(_keyUpupaCollection, cleaned);
    }
  }
}
