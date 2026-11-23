// lib/features/tools/presentation/pages/tool_detail/widgets/source_selector_dropdown.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';

class SourceSelectorDropdown extends StatelessWidget {
  final List<ToolSource> sources;
  final ToolSource selectedSource;
  final ValueChanged<ToolSource> onChanged;

  const SourceSelectorDropdown({
    super.key,
    required this.sources,
    required this.selectedSource,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<ToolSource>(
      initialValue: selectedSource,
      onSelected: onChanged,
      tooltip: 'Select package source',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => sources.map((source) {
        final isSelected = source.id == selectedSource.id;
        return PopupMenuItem<ToolSource>(
          value: source,
          child: SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        source.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                _metaRow(theme, 'URL', source.url),
                _metaRow(theme, 'Format', source.format),
                _metaRow(theme, 'Channel', source.channel),
                _metaRow(theme, 'Version', source.version),
              ],
            ),
          ),
        );
      }).toList(),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.45),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.source_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Source: ${selectedSource.label}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(ThemeData theme, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              key,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
