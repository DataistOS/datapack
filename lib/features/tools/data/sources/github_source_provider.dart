// lib/features/tools/data/sources/github_source_provider.dart
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';
import 'package:datapack/features/tools/data/sources/package_source_provider.dart';

class GitHubSourceProvider implements PackageSourceProvider {
  @override
  ToolSourceType get sourceType => ToolSourceType.github;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<List<ToolSource>> resolveSourcesForTool(Tool tool) async {
    final String repoUrl =
        tool.links['github'] ??
        tool.links['repository'] ??
        tool.links['source'] ??
        'https://github.com/DataistOS';

    return [
      ToolSource(
        id: 'github_${tool.id}_${tool.version}',
        label: 'GitHub Releases',
        type: ToolSourceType.github,
        url: repoUrl,
        format: tool.debFile.endsWith('.AppImage') ? 'AppImage' : 'DEB',
        channel: 'stable',
        version: tool.version,
        packageFile: tool.debFile,
        isAvailable: true,
      ),
    ];
  }

  @override
  Future<String> resolvePackageUrl(Tool tool, ToolSource source) async {
    if (source.packageFile.startsWith('http://') ||
        source.packageFile.startsWith('https://')) {
      return source.packageFile;
    }

    final String cleanUrl = source.url.endsWith('/')
        ? source.url.substring(0, source.url.length - 1)
        : source.url;

    if (source.packageFile.isEmpty) {
      return cleanUrl;
    }

    return '$cleanUrl/releases/latest/download/${source.packageFile}';
  }
}
