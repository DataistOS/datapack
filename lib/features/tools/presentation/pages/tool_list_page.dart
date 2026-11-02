// lib/features/tools/presentation/pages/tool_list_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datapack/core/services/tray_service.dart';
import 'package:datapack/features/tools/presentation/widgets/custom_app_bar.dart';
import 'package:datapack/features/tools/presentation/widgets/tool_card_widget.dart';
import 'package:datapack/features/tools/presentation/widgets/sort_filter_bar.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/presentation/widgets/terminal_dialog.dart';
import 'package:datapack/features/tools/presentation/widgets/system_storage_card.dart';
import 'package:datapack/features/tools/presentation/widgets/store_tab_bar.dart';
import 'package:datapack/features/tools/presentation/widgets/tool_shimmer_loading.dart';
import 'package:datapack/shared/pages/settings_page.dart';
import 'package:datapack/features/tools/presentation/pages/workspaces_page.dart';
import 'package:datapack/shared/pages/about_page.dart';

enum ToolTab { all, installed, updates, favorites, workspaces, about }

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
    _initTray();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToolProvider>().fetchTools();
    });
  }

  Future<void> _initTray() async {
    try {
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
      body: Consumer<ToolProvider>(
        builder: (context, provider, child) {
          final allTools = provider.tools;
          final totalCount = allTools.length;
          final installedCount = allTools.where((t) => t.isInstalled).length;
          final updatesCount = allTools.where((t) => t.hasUpdate).length;
          final favoritesCount = allTools.where((t) => t.isFavorite).length;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    StoreTabBar(
                      currentTab: _currentTab,
                      totalCount: totalCount,
                      installedCount: installedCount,
                      updatesCount: updatesCount,
                      favoritesCount: favoritesCount,
                      onTabChanged: (tab) => setState(() => _currentTab = tab),
                      onNavigateWorkspaces: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkspacesPage(),
                          ),
                        );
                      },
                      onNavigateAbout: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                    ),

                    if (_currentTab == ToolTab.all && _searchQuery.isEmpty) ...[
                      const SizedBox(height: 8),
                      const SystemStorageCard(),
                    ],

                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search software, packages, and tools...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.6,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.35),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(
                              0.2,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
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

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const ToolShimmerLoading();
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

                    if (provider.errorMessage != null &&
                        provider.tools.isEmpty) {
                      return Center(child: Text(provider.errorMessage!));
                    }

                    final tabFilteredTools = allTools.where((tool) {
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
                      final toolDescription =
                          tool.description?.toLowerCase() ?? '';
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
                              Icons.storefront_rounded,
                              size: 56,
                              color: theme.colorScheme.outline.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No software found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Check your spelling or try searching for something else.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => provider.fetchTools(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
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
          );
        },
      ),
    );
  }
}
