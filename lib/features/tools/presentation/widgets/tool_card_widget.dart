// lib/features/tools/presentation/widgets/tool_card_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/presentation/pages/tool_detail_page.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';

class ToolCard extends StatelessWidget {
  final Tool tool;
  final Function(BuildContext, Tool) onInstall;
  final Function(BuildContext, Tool) onUninstall;

  const ToolCard({
    super.key,
    required this.tool,
    required this.onInstall,
    required this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    final String? iconUrl = tool.icon;
    final theme = Theme.of(context);
    final isInstalled = tool.isInstalled;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: tool.isFavorite
              ? Colors.amber.withOpacity(0.6)
              : theme.colorScheme.outlineVariant.withOpacity(0.4),
          width: tool.isFavorite ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToolDetailPage(tool: tool),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: iconUrl != null && iconUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: iconUrl,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 52,
                              height: 52,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 52,
                              height: 52,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.extension_rounded,
                                size: 26,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.7),
                            child: Icon(
                              Icons.terminal_rounded,
                              color: theme.colorScheme.primary,
                              size: 26,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tool.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tool.version,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (tool.description != null &&
                          tool.description!.isNotEmpty)
                        Text(
                          tool.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      if (tool.tags.isNotEmpty)
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: tool.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                tag.trim(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                IconButton(
                  icon: Icon(
                    tool.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: tool.isFavorite
                        ? Colors.amber
                        : theme.colorScheme.outline,
                  ),
                  onPressed: () {
                    context.read<ToolProvider>().toggleFavorite(
                      tool.id.isNotEmpty ? tool.id : tool.name,
                    );
                  },
                  tooltip: tool.isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                ),
                const SizedBox(width: 8),

                SizedBox(
                  height: 38,
                  child: isInstalled
                      ? OutlinedButton.icon(
                          onPressed: () => onUninstall(context, tool),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 16,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(
                              color: theme.colorScheme.error.withOpacity(0.6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          label: const Text(
                            'Uninstall',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: () => onInstall(context, tool),
                          icon: const Icon(Icons.download_rounded, size: 16),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          label: const Text(
                            'Install',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
