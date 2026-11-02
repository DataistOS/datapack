class RegionModel {
  final String id;
  final String name;
  final String faName;
  final String province;
  final String timezone;
  final List<String> localTools;

  RegionModel({
    required this.id,
    required this.name,
    required this.faName,
    required this.province,
    required this.timezone,
    required this.localTools,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json, List<String> tools) {
    return RegionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      faName: json['fa_name'] ?? '',
      province: json['province'] ?? '',
      timezone: json['timezone'] ?? 'Asia/Tehran',
      localTools: tools,
    );
  }
}
