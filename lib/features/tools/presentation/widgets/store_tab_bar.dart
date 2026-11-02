// lib/features/tools/presentation/widgets/store_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/presentation/pages/tool_list_page.dart';

class StoreTabBar extends StatelessWidget {
  final ToolTab currentTab;
  final int totalCount;
  final int installedCount;
  final int updatesCount;
  final int favoritesCount;
  final ValueChanged<ToolTab> onTabChanged;
  final VoidCallback onNavigateWorkspaces;
  final VoidCallback onNavigateAbout;

  const StoreTabBar({
    super.key,
    required this.currentTab,
    required this.totalCount,
    required this.installedCount,
    required this.updatesCount,
    required this.favoritesCount,
    required this.onTabChanged,
    required this.onNavigateWorkspaces,
    required this.onNavigateAbout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton(
            context,
            'Explore',
            totalCount,
            ToolTab.all,
            Icons.explore_rounded,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            context,
            'Installed',
            installedCount,
            ToolTab.installed,
            Icons.check_circle_rounded,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            context,
            'Updates',
            updatesCount,
            ToolTab.updates,
            Icons.system_update_alt_rounded,
            badgeColor: updatesCount > 0 ? Colors.orange : null,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            context,
            'Favorites',
            favoritesCount,
            ToolTab.favorites,
            Icons.favorite_rounded,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            context,
            'Workspaces',
            null,
            ToolTab.workspaces,
            Icons.work_outline_rounded,
            onTapOverride: onNavigateWorkspaces,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            context,
            'About',
            null,
            ToolTab.about,
            Icons.info_outline_rounded,
            onTapOverride: onNavigateAbout,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label,
    int? count,
    ToolTab tab,
    IconData icon, {
    Color? badgeColor,
    VoidCallback? onTapOverride,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentTab == tab;

    return InkWell(
      onTap: onTapOverride ?? () => onTabChanged(tab),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.4)
                : theme.colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
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
                fontSize: 12.5,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      badgeColor ??
                      (isSelected
                          ? theme.colorScheme.primary.withOpacity(0.25)
                          : theme.colorScheme.onSurface.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: badgeColor != null
                        ? Colors.white
                        : (isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
