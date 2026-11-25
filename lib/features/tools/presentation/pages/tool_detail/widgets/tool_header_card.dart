// lib/features/tools/presentation/pages/tool_detail/widgets/tool_header_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';
import 'package:datapack/features/tools/presentation/pages/tool_detail/widgets/source_selector_dropdown.dart';

class ToolHeaderCard extends StatelessWidget {
  final Tool tool;
  final ToolSource? selectedSource;
  final ValueChanged<ToolSource>? onSourceChanged;
  final Function(BuildContext, Tool) onInstall;
  final Function(BuildContext, Tool) onUninstall;
  final Function(BuildContext, Tool, ToolSource)? onInstallWithSource;

  const ToolHeaderCard({
    super.key,
    required this.tool,
    this.selectedSource,
    this.onSourceChanged,
    required this.onInstall,
    required this.onUninstall,
    this.onInstallWithSource,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? iconUrl = tool.icon;
    final isInstalled = tool.isInstalled;
    final sources = tool.effectiveSources;
    final activeSource = selectedSource ?? tool.activeSource;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'tool-icon-${tool.name}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: iconUrl != null && iconUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: iconUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 72,
                          height: 72,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 72,
                          height: 72,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.extension_rounded,
                            size: 36,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Container(
                        width: 72,
                        height: 72,
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.8,
                        ),
                        child: Icon(
                          Icons.terminal_rounded,
                          color: theme.colorScheme.primary,
                          size: 36,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'v${activeSource.version.isNotEmpty ? activeSource.version : tool.version}',
                        style: TextStyle(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activeSource.channel,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (tool.hasUpdate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Update Available',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (onSourceChanged != null) ...[
            SourceSelectorDropdown(
              sources: sources,
              selectedSource: activeSource,
              onChanged: onSourceChanged!,
            ),
            const SizedBox(width: 10),
          ],
          SizedBox(
            height: 40,
            child: isInstalled
                ? OutlinedButton(
                    onPressed: () => onUninstall(context, tool),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                        color: theme.colorScheme.error.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      'Uninstall',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : FilledButton(
                    onPressed: () {
                      if (onInstallWithSource != null) {
                        onInstallWithSource!(context, tool, activeSource);
                      } else {
                        onInstall(context, tool);
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text(
                      'Install',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
