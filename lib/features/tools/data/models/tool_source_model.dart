// lib/features/tools/data/models/tool_source_model.dart
enum ToolSourceType { github, upupa, custom }

class ToolSource {
  final String id;
  final String label;
  final ToolSourceType type;
  final String url;
  final String format;
  final String channel;
  final String version;
  final String packageFile;
  final bool isAvailable;

  const ToolSource({
    required this.id,
    required this.label,
    required this.type,
    required this.url,
    this.format = 'DEB',
    this.channel = 'stable',
    required this.version,
    this.packageFile = '',
    this.isAvailable = true,
  });

  ToolSource copyWith({
    String? id,
    String? label,
    ToolSourceType? type,
    String? url,
    String? format,
    String? channel,
    String? version,
    String? packageFile,
    bool? isAvailable,
  }) {
    return ToolSource(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      url: url ?? this.url,
      format: format ?? this.format,
      channel: channel ?? this.channel,
      version: version ?? this.version,
      packageFile: packageFile ?? this.packageFile,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() =>
      'ToolSource(id: $id, label: $label, type: $type, channel: $channel, version: $version)';
}
