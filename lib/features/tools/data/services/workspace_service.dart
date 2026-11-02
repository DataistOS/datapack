// lib/features/tools/data/services/workspace_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:datapack/features/tools/data/models/workspace_model.dart';

class WorkspaceService {
  final List<String> _categoryFolders = [
    '00_dataist',
    '01_AgriTech_Bio',
    '02_Manufacturing',
    '03_Energy_Utilities',
    '04_Finance_FinTech',
    '05_Logistics_Supply',
    '06_Health_Wellness',
    '07_Education_Knowledge',
    '08_Art_Media_Ent',
    '09_IT_Software_Telecom',
    '10_Retail_Services',
  ];

  Future<List<WorkspaceCategory>> loadWorkspaces() async {
    List<WorkspaceCategory> categories = [];
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = assetManifest.listAssets();

    for (String folder in _categoryFolders) {
      try {
        final basePath = 'assets/taxonomies/$folder';

        String categoryName = _formatFolderName(folder);
        try {
          final metadataString = await rootBundle.loadString(
            '$basePath/metadata.json',
          );
          final metadataJson = json.decode(metadataString);
          if (metadataJson['name'] != null) {
            categoryName = metadataJson['name'];
          }
        } catch (_) {}

        final subcategoryNames = <String>{};
        final subPrefix = '$basePath/subcategories/';

        for (String asset in assets) {
          if (asset.startsWith(subPrefix)) {
            final relativePath = asset.substring(subPrefix.length);
            final parts = relativePath.split('/');
            if (parts.isNotEmpty && parts[0].isNotEmpty) {
              subcategoryNames.add(parts[0]);
            }
          }
        }

        List<WorkspaceSubcategory> subcategories = [];
        for (String subName in subcategoryNames) {
          final subBasePath = '$subPrefix$subName';
          List<String> basePackages = [];

          try {
            final packagesText = await rootBundle.loadString(
              '$subBasePath/base-packages.txt',
            );
            basePackages = packagesText
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty && !e.startsWith('#'))
                .toList();
          } catch (_) {}

          subcategories.add(
            WorkspaceSubcategory(
              id: subName,
              name: subName.replaceAll('_', ' '),
              basePackages: basePackages,
            ),
          );
        }

        categories.add(
          WorkspaceCategory(
            id: folder,
            name: categoryName,
            subcategories: subcategories,
          ),
        );
      } catch (e) {
        debugPrint('Error loading workspace category $folder: $e');
      }
    }

    return categories;
  }

  String _formatFolderName(String folderName) {
    return folderName.replaceAll(RegExp(r'^\d+_'), '').replaceAll('_', ' & ');
  }
}
