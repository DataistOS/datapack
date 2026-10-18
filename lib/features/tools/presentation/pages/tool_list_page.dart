// lib/features/tools/presentation/pages/tool_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datapack/features/tools/presentation/widgets/custom_app_bar.dart';
import 'package:datapack/features/tools/presentation/widgets/tool_card_widget.dart';
import 'package:datapack/features/tools/presentation/widgets/sort_filter_bar.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';

class ToolListPage extends StatefulWidget {
  const ToolListPage({super.key});

  @override
  State<ToolListPage> createState() => _ToolListPageState();
}

class _ToolListPageState extends State<ToolListPage> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.nameAsc;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh(BuildContext context) {
    context.read<ToolProvider>().fetchTools();
  }

  Future<void> _onInstallTool(BuildContext context, tool) async {
    final provider = context.read<ToolProvider>();
    final success = await provider.installTool(tool.name);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '${tool.name} installed successfully!' : (provider
                .errorMessage ?? 'Install failed'),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onUninstallTool(BuildContext context, tool) async {
    final provider = context.read<ToolProvider>();
    final success = await provider.uninstallTool(tool.name);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '${tool.name} uninstalled successfully!' : (provider
                .errorMessage ?? 'Uninstall failed'),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(onRefresh: () => _onRefresh(context)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tools...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => _searchController.clear(),
                    )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SortFilterBar(
                  selectedOption: _currentSortOption,
                  onOptionChanged: (SortOption? newOption) {
                    if (newOption != null) {
                      setState(() {
                        _currentSortOption = newOption;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: Consumer<ToolProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.isActionInProgress) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(provider.actionMessage ?? 'Processing...'),
                      ],
                    ),
                  );
                }

                if (provider.errorMessage != null && provider.tools.isEmpty) {
                  return Center(child: Text(provider.errorMessage!));
                }

                final tools = provider.tools;
                final searchTerm = _searchController.text.toLowerCase();
                final filteredTools = tools.where((tool) {
                  final toolName = tool.name.toLowerCase();
                  final toolDescription = tool.description?.toLowerCase() ?? '';
                  final toolTags = tool.tags.join(' ').toLowerCase();
                  return toolName.contains(searchTerm) ||
                      toolDescription.contains(searchTerm) ||
                      toolTags.contains(searchTerm);
                }).toList();

                filteredTools.sort((a, b) {
                  switch (_currentSortOption) {
                    case SortOption.nameAsc:
                      return a.name.compareTo(b.name);
                    case SortOption.nameDesc:
                      return b.name.compareTo(a.name);
                    case SortOption.versionAsc:
                      return a.version.compareTo(b.version);
                    case SortOption.versionDesc:
                      return b.version.compareTo(a.version);
                    case SortOption.tagsAsc:
                      if (a.tags.isEmpty && b.tags.isEmpty) return 0;
                      if (a.tags.isEmpty) return 1;
                      if (b.tags.isEmpty) return -1;
                      return a.tags.first.compareTo(b.tags.first);
                  }
                });

                if (filteredTools.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48,
                            color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text('No tools found for this search.',
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchTools(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredTools.length,
                    itemBuilder: (context, index) {
                      final tool = filteredTools[index];
                      return ToolCard(
                        tool: tool,
                        onInstall: _onInstallTool,
                        onUninstall: _onUninstallTool,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}