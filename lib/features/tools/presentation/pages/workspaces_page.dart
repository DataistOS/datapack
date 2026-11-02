// lib/features/tools/presentation/pages/workspaces_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datapack/features/tools/presentation/providers/workspace_provider.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/data/services/region_service.dart';
import 'package:datapack/features/tools/data/models/region_model.dart';
import 'package:datapack/features/tools/data/models/workspace_model.dart'; // مسیر صحیح و یکتا با Provider
import 'package:datapack/features/tools/presentation/widgets/terminal_dialog.dart';
import 'package:datapack/features/tools/presentation/widgets/workspace_banner.dart';

class WorkspacesPage extends StatefulWidget {
  const WorkspacesPage({super.key});

  @override
  State<WorkspacesPage> createState() => _WorkspacesPageState();
}

class _WorkspacesPageState extends State<WorkspacesPage> {
  final RegionService _regionService = RegionService();
  List<RegionModel> _regions = [];
  bool _isLoadingRegions = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkspaceProvider>().fetchWorkspaces();
      _loadRegions();
    });
  }

  Future<void> _loadRegions() async {
    final regions = await _regionService.fetchRegions();
    setState(() {
      _regions = regions;
      _isLoadingRegions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Workspaces & Regional Stacks'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Consumer<WorkspaceProvider>(
        builder: (context, workspaceProvider, child) {
          if (workspaceProvider.isLoading || _isLoadingRegions) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const WorkspaceBanner(
                title: 'Choose Your Industry & Region',
                subtitle:
                    'Select your professional industry workspace or local city app stack to instantly access and install.',
                bannerIcon: Icons.auto_fix_high_rounded,
              ),
              const SizedBox(height: 20),

              if (_regions.isNotEmpty) ...[
                Text(
                  'Regional & City Stacks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                ..._regions.map((region) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: theme.colorScheme.secondaryContainer.withOpacity(
                      0.3,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        '${region.faName} (${region.name})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Province: ${region.province} • ${region.localTools.length} local packages',
                      ),
                      leading: const Icon(Icons.location_city_rounded),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...region.localTools.map(
                                (tool) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(tool),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _installRegionStack(context, region),
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    size: 16,
                                  ),
                                  label: const Text('Install Regional Stack'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],

              Text(
                'Industry Workspaces',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              ...workspaceProvider.categories.map((category) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${category.subcategories.length} Subcategories',
                    ),
                    leading: const Icon(Icons.work_outline_rounded),
                    children: category.subcategories.map((sub) {
                      return ListTile(
                        title: Text(sub.name),
                        subtitle: Text(
                          '${sub.basePackages.length} base packages',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          _showSubcategoryDetails(context, sub);
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Future<void> _installRegionStack(
    BuildContext context,
    RegionModel region,
  ) async {
    final toolProvider = context.read<ToolProvider>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TerminalDialog(
        title: 'Installing Region Stack: ${region.faName}',
        action: (onLog) async {
          bool overallSuccess = true;
          onLog(
            'Preparing local stack for ${region.faName} (${region.name})...',
          );
          await Future.delayed(const Duration(milliseconds: 500));

          for (String packageName in region.localTools) {
            onLog('----------------------------------------');
            onLog('Installing package: $packageName ...');

            final success = await toolProvider.installTool(packageName);

            if (success) {
              onLog('Successfully installed: $packageName');
            } else {
              onLog('Warning/Failed to install: $packageName');
              overallSuccess = false;
            }
            await Future.delayed(const Duration(milliseconds: 300));
          }

          onLog('----------------------------------------');
          onLog(
            overallSuccess
                ? 'Regional stack installation completed successfully!'
                : 'Regional stack installation completed with some errors.',
          );
          return overallSuccess;
        },
      ),
    );

    if (context.mounted) {
      toolProvider.fetchTools();
    }
  }

  void _showSubcategoryDetails(BuildContext context, WorkspaceSubcategory sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(sub.name),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Tool Stack (${sub.basePackages.length} packages):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...sub.basePackages.map(
                  (pkg) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(pkg)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _installWorkspaceStack(context, sub);
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Install Workspace Stack'),
          ),
        ],
      ),
    );
  }

  Future<void> _installWorkspaceStack(
    BuildContext context,
    WorkspaceSubcategory sub,
  ) async {
    final toolProvider = context.read<ToolProvider>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TerminalDialog(
        title: 'Installing Workspace: ${sub.name}',
        action: (onLog) async {
          bool overallSuccess = true;
          onLog('Preparing workspace stack for ${sub.name}...');
          await Future.delayed(const Duration(milliseconds: 500));

          for (String packageName in sub.basePackages) {
            onLog('----------------------------------------');
            onLog('Installing package: $packageName ...');

            final success = await toolProvider.installTool(packageName);

            if (success) {
              onLog('Successfully installed: $packageName');
            } else {
              onLog('Warning/Failed to install: $packageName');
              overallSuccess = false;
            }
            await Future.delayed(const Duration(milliseconds: 300));
          }

          onLog('----------------------------------------');
          onLog(
            overallSuccess
                ? 'Workspace stack installation completed successfully!'
                : 'Workspace stack installation completed with some errors.',
          );
          return overallSuccess;
        },
      ),
    );

    if (context.mounted) {
      toolProvider.fetchTools();
    }
  }
}
