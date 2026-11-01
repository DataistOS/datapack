// lib/features/tools/presentation/pages/tool_list_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:datapack/core/services/tray_service.dart';
import 'package:datapack/features/tools/presentation/widgets/custom_app_bar.dart';
import 'package:datapack/features/tools/presentation/widgets/tool_card_widget.dart';
import 'package:datapack/features/tools/presentation/widgets/sort_filter_bar.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/presentation/widgets/terminal_dialog.dart';
import 'package:datapack/shared/pages/settings_page.dart';

enum ToolTab { all, installed, updates, favorites }

class ToolListPage extends StatefulWidget {
  const ToolListPage({super.key});

  @override
  State<ToolListPage> createState() => _ToolListPageState();
}

class _ToolListPageState extends State<ToolListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  SortOption _currentSortOption = SortOption.nameAsc;
  ToolTab _currentTab = ToolTab.all;
  String? _selectedTagFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _initTrayAndWindow();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToolProvider>().fetchTools();
    });
  }

  Future<void> _initTrayAndWindow() async {
    try {
      await windowManager.setPreventClose(true);
      await TrayService().initTray();
    } catch (_) {}
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh(BuildContext context) {
    context.read<ToolProvider>().fetchTools();
  }

  Future<void> _onInstallTool(BuildContext context, tool) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TerminalDialog(
        title: 'Installing ${tool.name}',
        action: (onLog) async {
          onLog('Preparing environment for ${tool.name}...');
          await Future.delayed(const Duration(milliseconds: 500));
          final provider = context.read<ToolProvider>();
          onLog('Executing system installation command...');
          final success = await provider.installTool(tool.name);
          onLog(
            success
                ? 'Package successfully installed!'
                : (provider.errorMessage ?? 'Installation failed.'),
          );
          return success;
        },
      ),
    );
    if (context.mounted) context.read<ToolProvider>().fetchTools();
  }

  Future<void> _onUninstallTool(BuildContext context, tool) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TerminalDialog(
        title: 'Uninstalling ${tool.name}',
        action: (onLog) async {
          onLog('Preparing to remove ${tool.name}...');
          await Future.delayed(const Duration(milliseconds: 500));
          final provider = context.read<ToolProvider>();
          onLog('Executing system removal command...');
          final success = await provider.uninstallTool(tool.name);
          onLog(
            success
                ? 'Package successfully uninstalled!'
                : (provider.errorMessage ?? 'Uninstallation failed.'),
          );
          return success;
        },
      ),
    );
    if (context.mounted) context.read<ToolProvider>().fetchTools();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        onRefresh: () => _onRefresh(context),
        onOpenSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(onThemeChanged: (isDark) {}),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            color: theme.colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton(
                    context,
                    'All Tools',
                    ToolTab.all,
                    Icons.apps_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildTabButton(
                    context,
                    'Installed',
                    ToolTab.installed,
                    Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildTabButton(
                    context,
                    'Updates',
                    ToolTab.updates,
                    Icons.system_update_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildTabButton(
                    context,
                    'Favorites',
                    ToolTab.favorites,
                    Icons.star_rounded,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tools by name, tag or description...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withOpacity(
                          0.3,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withOpacity(
                          0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SortFilterBar(
                  selectedOption: _currentSortOption,
                  onOptionChanged: (SortOption? newOption) {
                    if (newOption != null) {
                      setState(() => _currentSortOption = newOption);
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
                  return _buildShimmerLoading(theme);
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

                final tabFilteredTools = tools.where((tool) {
                  switch (_currentTab) {
                    case ToolTab.installed:
                      return tool.isInstalled;
                    case ToolTab.updates:
                      return tool.hasUpdate;
                    case ToolTab.favorites:
                      return tool.isFavorite;
                    case ToolTab.all:
                    default:
                      return true;
                  }
                }).toList();

                final searchedTools = tabFilteredTools.where((tool) {
                  final toolName = tool.name.toLowerCase();
                  final toolDescription = tool.description?.toLowerCase() ?? '';
                  final toolTags = tool.tags.join(' ').toLowerCase();
                  return toolName.contains(_searchQuery) ||
                      toolDescription.contains(_searchQuery) ||
                      toolTags.contains(_searchQuery);
                }).toList();

                final filteredTools = searchedTools.where((tool) {
                  if (_selectedTagFilter == null) return true;
                  return tool.tags.contains(_selectedTagFilter);
                }).toList();

                filteredTools.sort((a, b) {
                  if (a.isFavorite && !b.isFavorite) return -1;
                  if (!a.isFavorite && b.isFavorite) return 1;

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
                        Icon(
                          Icons.search_off_rounded,
                          size: 54,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tools found in this section.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildTabButton(
    BuildContext context,
    String label,
    ToolTab tab,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _currentTab == tab;

    return InkWell(
      onTap: () => setState(() => _currentTab = tab),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 10,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
