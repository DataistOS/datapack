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
            success ? 'Uninstalled successfully!' : (provider.errorMessage ??
                'Uninstall failed'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onRefresh: () => _onRefresh(context)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: const Icon(Icons.search),
              hintText: 'Search for tools...',
            ),
          ),
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
                  return const Center(
                    child: Text('No tools found for this search.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchTools(),
                  child: ListView.builder(
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