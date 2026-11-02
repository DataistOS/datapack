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
