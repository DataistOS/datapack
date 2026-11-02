// lib/core/services/cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/core/services/logging_service.dart';

class CacheService {
  static const String _keyCachedTools = 'cached_tools_list';

  static Future<void> cacheTools(List<Tool> tools) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final jsonList = tools
          .map(
            (tool) => {
              'id': tool.id,
              'name': tool.name,
              'version': tool.version,
              'description': tool.description,
              'changelog': tool.changelog,
              'icon': tool.icon,
              'deb_file': tool.debFile,
              'tags': tool.tags,
              'isInstalled': tool.isInstalled,
              'hasUpdate': tool.hasUpdate,
              'isFavorite': tool.isFavorite,
            },
          )
          .toList();

      await prefs.setString(_keyCachedTools, jsonEncode(jsonList));
      await LoggingService.log('Tools successfully cached locally.');
    } catch (e) {
      await LoggingService.log('Failed to cache tools: $e', level: 'ERROR');
    }
  }

  static Future<List<Tool>> getCachedTools() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_keyCachedTools);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return decodedList
            .map((item) => Tool.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      await LoggingService.log(
        'Failed to load cached tools: $e',
        level: 'ERROR',
      );
    }
    return [];
  }
}
