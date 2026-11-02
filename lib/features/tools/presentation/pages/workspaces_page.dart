// lib/features/tools/presentation/pages/workspaces_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datapack/features/tools/presentation/providers/workspace_provider.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/data/models/workspace_model.dart';
import 'package:datapack/features/tools/presentation/widgets/terminal_dialog.dart';
import 'package:datapack/features/tools/presentation/widgets/workspace_banner.dart';

class WorkspacesPage extends StatefulWidget {
  const WorkspacesPage({super.key});

  @override
  State<WorkspacesPage> createState() => _WorkspacesPageState();
}

class _WorkspacesPageState extends State<WorkspacesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkspaceProvider>().fetchWorkspaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Industry Workspaces'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Consumer<WorkspaceProvider>(
        builder: (context, workspaceProvider, child) {
          if (workspaceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workspaceProvider.errorMessage != null) {
            return Center(child: Text(workspaceProvider.errorMessage!));
          }

          if (workspaceProvider.categories.isEmpty) {
            return const Center(child: Text('No workspaces found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const WorkspaceBanner(
                title: 'Choose Your Industry & Workflow',
                subtitle:
                    'Select your professional workspace below to instantly access and manage dedicated tool stacks.',
                bannerIcon: Icons.auto_fix_high_rounded,
              ),
              const SizedBox(height: 20),
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
