// lib/features/tools/data/sources/tool_source_resolver.dart
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';
import 'package:datapack/features/tools/data/sources/package_source_provider.dart';

class ToolSourceResolver {
  final List<PackageSourceProvider> providers;

  const ToolSourceResolver({required this.providers});

  Future<List<ToolSource>> resolveAllSources(Tool tool) async {
    final List<ToolSource> aggregatedSources = [];

    for (final provider in providers) {
      try {
        final available = await provider.isAvailable();
        if (!available) continue;

        final sources = await provider.resolveSourcesForTool(tool);
        aggregatedSources.addAll(sources.where((s) => s.isAvailable));
      } catch (_) {
        continue;
      }
    }

    return aggregatedSources;
  }

  PackageSourceProvider? providerForType(ToolSourceType type) {
    for (final provider in providers) {
      if (provider.sourceType == type) {
        return provider;
      }
    }
    return null;
  }

  Future<String?> resolveDownloadUrl(Tool tool, ToolSource source) async {
    final provider = providerForType(source.type);
    if (provider == null) return null;
    return provider.resolvePackageUrl(tool, source);
  }
}
