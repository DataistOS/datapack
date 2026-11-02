// lib/features/tools/data/models/workspace_model.dart
class WorkspaceCategory {
  final String id;
  final String name;
  final List<WorkspaceSubcategory> subcategories;

  const WorkspaceCategory({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  factory WorkspaceCategory.fromJson(
    String id,
    Map<String, dynamic> json,
    List<WorkspaceSubcategory> subcategories,
  ) {
    return WorkspaceCategory(
      id: id,
      name: json['name'] ?? id,
      subcategories: subcategories,
    );
  }
}

class WorkspaceSubcategory {
  final String id;
  final String name;
  final List<String> basePackages;

  const WorkspaceSubcategory({
    required this.id,
    required this.name,
    required this.basePackages,
  });
}
