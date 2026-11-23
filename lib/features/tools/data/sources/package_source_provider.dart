// lib/features/tools/data/sources/package_source_provider.dart
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';

abstract class PackageSourceProvider {
  ToolSourceType get sourceType;

  Future<bool> isAvailable();

  Future<List<ToolSource>> resolveSourcesForTool(Tool tool);

  Future<String> resolvePackageUrl(Tool tool, ToolSource source);
}
