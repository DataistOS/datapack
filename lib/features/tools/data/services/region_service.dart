// lib/features/tools/data/services/region_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:datapack/features/tools/data/models/region_model.dart';

class RegionService {
  Future<List<RegionModel>> fetchRegions() async {
    try {
      final manifestContent = await rootBundle.loadString(
        'assets/regions/metadata.json',
      );
      print('RegionService: Loaded regions/metadata.json successfully.');
      print('RAW manifestContent: $manifestContent');

      final Map<String, dynamic> manifestData = json.decode(manifestContent);
      final List regionsList = manifestData['regions'] ?? [];
      print('Parsed regions count: ${regionsList.length}');

      List<RegionModel> loadedRegions = [];

      for (var reg in regionsList) {
        final String folderName = reg['folder'] ?? '';
        print('Checking region folder: $folderName');

        if (folderName.isNotEmpty) {
          try {
            final regMetaPath = 'assets/regions/$folderName/metadata.json';
            final regMetaContent = await rootBundle.loadString(regMetaPath);
            final Map<String, dynamic> regMeta = json.decode(regMetaContent);

            final toolsPath = 'assets/regions/$folderName/local-tools.json';
            final toolsContent = await rootBundle.loadString(toolsPath);
            final Map<String, dynamic> toolsData = json.decode(toolsContent);

            final List toolsJson = toolsData['tools'] ?? [];
            List<String> toolNames = toolsJson
                .map((t) => t['name'].toString())
                .toList();

            loadedRegions.add(RegionModel.fromJson(regMeta, toolNames));
            print(
              'RegionService: Successfully loaded region -> $folderName with ${toolNames.length} tools',
            );
          } catch (subError) {
            print(
              'RegionService Error reading region folder "$folderName": $subError',
            );
          }
        }
      }

      return loadedRegions;
    } catch (e) {
      print('RegionService ERROR in fetchRegions: $e');
      return [];
    }
  }
}
