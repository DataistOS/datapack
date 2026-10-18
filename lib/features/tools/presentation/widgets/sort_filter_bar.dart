// lib/features/tools/presentation/widgets/sort_filter_bar.dart

import 'package:flutter/material.dart';

enum SortOption { nameAsc, nameDesc, versionAsc, versionDesc, tagsAsc }

class SortFilterBar extends StatelessWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption?> onOptionChanged;

  const SortFilterBar({
    super.key,
    required this.selectedOption,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.sort, size: 16,
                color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              'Sort by',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        PopupMenuButton<SortOption>(
          initialValue: selectedOption,
          onSelected: onOptionChanged,
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) =>
          [
            const PopupMenuItem(
                value: SortOption.nameAsc, child: Text('Name (A-Z)')),
            const PopupMenuItem(
                value: SortOption.nameDesc, child: Text('Name (Z-A)')),
            const PopupMenuItem(
                value: SortOption.versionDesc, child: Text('Version (Newest)')),
            const PopupMenuItem(
                value: SortOption.versionAsc, child: Text('Version (Oldest)')),
            const PopupMenuItem(
                value: SortOption.tagsAsc, child: Text('Tags (A-Z)')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  _getSortLabel(selectedOption),
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.versionAsc:
        return 'Version (Oldest)';
      case SortOption.versionDesc:
        return 'Version (Newest)';
      case SortOption.tagsAsc:
        return 'Tags (A-Z)';
    }
  }
}