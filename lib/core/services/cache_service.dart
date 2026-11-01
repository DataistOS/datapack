// lib/core/services/cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datapack/core/services/logging_service.dart';

class CacheService {
  static const String _keyCachedTools = 'cached_tools_list';

  static Future<void> cacheTools(List<ToolModel> tools) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var jsonList = tools
          .map(
            (tool) => {
              'name': tool.name,
              'description': tool.description,
              'version': tool.version,
              'isInstalled': tool.isInstalled,
              'icon': tool.icon,
              'tags': tool.tags,
            },
          )
          .toList();

      await prefs.setString(_keyCachedTools, jsonEncode(jsonList));
      await LoggingService.log('Tools successfully cached locally.');
    } catch (e) {
      await LoggingService.log('Failed to cache tools: $e', level: 'ERROR');
    }
  }

  static Future<List<ToolModel>> getCachedTools() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_keyCachedTools);

      if (jsonString != null) {
        List decodedList = jsonDecode(jsonString);
        return decodedList
            .map(
              (item) => ToolModel(
                name: item['name'] ?? '',
                description: item['description'],
                version: item['version'] ?? '1.0.0',
                isInstalled: item['isInstalled'] ?? false,
                icon: item['icon'],
                tags: List<String>.from(item['tags'] ?? []),
              ),
            )
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
