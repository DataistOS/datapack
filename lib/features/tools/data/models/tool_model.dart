// lib/features/tools/data/models/tool_model.dart

class Tool {
  final String id;
  final String name;
  final String version;
  final String? description;
  final String? changelog;
  final String? icon;
  final String debFile;
  final List<String> tags;

  final bool isInstalled;
  final bool hasUpdate;

  Tool({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    this.changelog,
    this.icon,
    required this.debFile,
    required this.tags,
    this.isInstalled = false,
    this.hasUpdate = false,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      version: json['version']?.toString() ?? '0.0.0',
      description: json['description']?.toString(),
      changelog: json['changelog']?.toString(),
      icon: json['icon']?.toString(),
      debFile: json['deb_file']?.toString() ?? '',
      tags: json['tags'] is String
          ? (json['tags'] as String).split(',').map((e) => e.trim()).toList()
          : (json['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Tool copyWith({bool? isInstalled, bool? hasUpdate}) {
    return Tool(
      id: id,
      name: name,
      version: version,
      description: description,
      changelog: changelog,
      icon: icon,
      debFile: debFile,
      tags: tags,
      isInstalled: isInstalled ?? this.isInstalled,
      hasUpdate: hasUpdate ?? this.hasUpdate,
    );
  }

  @override
  String toString() => 'Tool(name: $name, version: $version)';
}