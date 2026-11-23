// lib/features/tools/data/sources/upupa_source_provider.dart
import 'package:datapack/core/services/settings_service.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';
import 'package:datapack/features/tools/data/sources/package_source_provider.dart';
import 'package:upupa_dart/upupa_dart.dart';

class UpUpaSourceProvider implements PackageSourceProvider {
  final String? Function()? baseUrlProvider;
  final String? collectionNameOverride;

  UpUpaSourceProvider({this.baseUrlProvider, this.collectionNameOverride});

  @override
  ToolSourceType get sourceType => ToolSourceType.upupa;

  String? _normalizeUrl(String? raw) {
    final trimmed = raw?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  Future<String?> _resolveBaseUrl() async {
    final enabled = await SettingsService.isUpupaSourceEnabled();
    if (!enabled) return null;

    final fromSettings = await SettingsService.getUpupaServerUrl();
    final fromProvider = baseUrlProvider?.call();
    return _normalizeUrl(fromSettings ?? fromProvider);
  }

  Future<String> _resolveCollectionName() async {
    if (collectionNameOverride != null &&
        collectionNameOverride!.trim().isNotEmpty) {
      return collectionNameOverride!.trim();
    }
    return SettingsService.getUpupaCollectionName();
  }

  @override
  Future<bool> isAvailable() async {
    final url = await _resolveBaseUrl();
    return url != null;
  }

  bool _matchesTool(Record record, Tool tool) {
    final data = record.data;
    final candidateNames = [
      data['name'],
      data['package_name'],
      data['packageName'],
      data['tool_name'],
      data['slug'],
      data['id'],
    ].whereType<String>().map((e) => e.trim().toLowerCase()).toList();

    final targetName = tool.name.trim().toLowerCase();
    final targetId = tool.id.trim().toLowerCase();

    return candidateNames.contains(targetName) ||
        (targetId.isNotEmpty && candidateNames.contains(targetId));
  }

  String _extractPackageFile(Record record, Tool tool) {
    final data = record.data;
    final rawFile =
        (data['deb_file'] ??
                data['debFile'] ??
                data['package_file'] ??
                data['packageFile'] ??
                data['download_url'] ??
                data['downloadUrl'] ??
                data['url'] ??
                tool.debFile)
            ?.toString()
            .trim() ??
        '';
    return rawFile;
  }

  @override
  Future<List<ToolSource>> resolveSourcesForTool(Tool tool) async {
    final baseUrl = await _resolveBaseUrl();
    if (baseUrl == null) return [];

    final collectionName = await _resolveCollectionName();
    final client = UpupaClient(baseUrl);

    try {
      final records = await client.records.getList(collectionName, perPage: 50);

      final matched = records.where((r) => _matchesTool(r, tool)).toList();
      if (matched.isEmpty) return [];

      return matched.map((record) {
        final data = record.data;
        final version = (data['version'] ?? tool.version).toString();
        final channel = (data['channel'] ?? 'local').toString();
        final format =
            (data['format'] ??
                    (tool.debFile.endsWith('.AppImage') ? 'AppImage' : 'DEB'))
                .toString();
        final packageFile = _extractPackageFile(record, tool);

        return ToolSource(
          id: 'upupa_${tool.id}_${record.id}_$version',
          label: 'UpUpa Local Server',
          type: ToolSourceType.upupa,
          url: baseUrl,
          format: format,
          channel: channel,
          version: version,
          packageFile: packageFile,
          isAvailable: true,
        );
      }).toList();
    } catch (_) {
      return [];
    } finally {
      client.dispose();
    }
  }

  @override
  Future<String> resolvePackageUrl(Tool tool, ToolSource source) async {
    final baseUrl =
        await _resolveBaseUrl() ?? _normalizeUrl(source.url) ?? source.url;
    final filePath = source.packageFile.trim();

    if (filePath.isEmpty) {
      return '$baseUrl/packages/${tool.name}/${tool.debFile}';
    }

    if (filePath.startsWith('http://') || filePath.startsWith('https://')) {
      return filePath;
    }

    final cleanPath = filePath.startsWith('/')
        ? filePath.substring(1)
        : filePath;
    return '$baseUrl/$cleanPath';
  }
}
