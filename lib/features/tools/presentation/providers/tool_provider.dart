// lib/features/tools/presentation/providers/tool_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/core/platform/system_commands.dart';

class ToolProvider extends ChangeNotifier {
  final String _toolsUrl = dotenv.env['REGISTRY_URL'] ?? '';

  List<Tool> _tools = [];
  bool _isLoading = false;
  bool _isActionInProgress = false;
  String? _actionMessage;
  String? _errorMessage;

  List<Tool> get tools => _tools;
  bool get isLoading => _isLoading;
  bool get isActionInProgress => _isActionInProgress;
  String? get actionMessage => _actionMessage;
  String? get errorMessage => _errorMessage;

  static const String _favoritesKey = 'favorite_tools_ids';

  Future<Set<String>> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? [];
    return list.toSet();
  }

  Future<void> _saveFavoritesToPrefs(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> fetchTools() async {
    if (_toolsUrl.isEmpty) {
      _errorMessage = 'Registry URL is not configured in .env file.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_toolsUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final favoriteIds = await _loadFavoritesFromPrefs();

        _tools = await Future.wait(
          data.map((item) async {
            final tool = Tool.fromJson(item);
            final bool isInstalled = await SystemCommands.isToolInstalled(
              tool.name,
            );
            final String? installedVersion =
                await SystemCommands.getInstalledVersion(tool.name);
            final bool hasUpdate =
                isInstalled && installedVersion != tool.version;
            final bool isFavorite = favoriteIds.contains(
              tool.id.isNotEmpty ? tool.id : tool.name,
            );

            return tool.copyWith(
              isInstalled: isInstalled,
              hasUpdate: hasUpdate,
              isFavorite: isFavorite,
            );
          }).toList(),
        );
      } else {
        _errorMessage = 'Failed to load tools: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String toolId) async {
    final index = _tools.indexWhere((t) => t.id == toolId || t.name == toolId);
    if (index != -1) {
      final tool = _tools[index];
      final updatedFavorite = !tool.isFavorite;
      _tools[index] = tool.copyWith(isFavorite: updatedFavorite);

      final favoriteIds = _tools
          .where((t) => t.isFavorite)
          .map((t) => t.id.isNotEmpty ? t.id : t.name)
          .toSet();
      await _saveFavoritesToPrefs(favoriteIds);
      notifyListeners();
    }
  }

  Future<bool> installTool(String packageName) async {
    _isActionInProgress = true;
    _actionMessage = 'Downloading and installing $packageName...';
    notifyListeners();

    try {
      final tool = _tools.firstWhere(
        (t) => t.name == packageName,
        orElse: () =>
            throw Exception('Package $packageName not found in registry.'),
      );

      final response = await http.get(Uri.parse(tool.debFile));

      if (response.statusCode == 200) {
        final file = File('/tmp/${tool.name}.deb');
        await file.writeAsBytes(response.bodyBytes);

        final result = await SystemCommands.installDebPackage(file.path);

        if (result.exitCode == 0) {
          _actionMessage = '${tool.name} installed successfully!';
          await fetchTools();
          return true;
        } else {
          _errorMessage = 'Install failed: ${result.stderr}';
          return false;
        }
      } else {
        _errorMessage = 'Download failed: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  Future<bool> uninstallTool(String packageName) async {
    _isActionInProgress = true;
    _actionMessage = 'Uninstalling $packageName...';
    notifyListeners();

    try {
      final result = await SystemCommands.removePackage(packageName);

      if (result.exitCode == 0) {
        _actionMessage = 'Uninstalled successfully!';
        await fetchTools();
        return true;
      } else {
        _errorMessage = 'Failed: ${result.stderr}';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }
}
