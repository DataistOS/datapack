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
  final Map<String, String> links;

  final bool isInstalled;
  final bool hasUpdate;
  final bool isFavorite;

  const Tool({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    this.changelog,
    this.icon,
    required this.debFile,
    required this.tags,
    this.links = const {},
    this.isInstalled = false,
    this.hasUpdate = false,
    this.isFavorite = false,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    Map<String, String> parsedLinks = {};
    if (json['links'] is Map) {
      (json['links'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null) {
          parsedLinks[key] = value.toString();
        }
      });
    }

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
      links: parsedLinks,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Tool copyWith({bool? isInstalled, bool? hasUpdate, bool? isFavorite}) {
    return Tool(
      id: id,
      name: name,
      version: version,
      description: description,
      changelog: changelog,
      icon: icon,
      debFile: debFile,
      tags: tags,
      links: links,
      isInstalled: isInstalled ?? this.isInstalled,
      hasUpdate: hasUpdate ?? this.hasUpdate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() =>
      'Tool(name: $name, version: $version, favorite: $isFavorite)';
}
