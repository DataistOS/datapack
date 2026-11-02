// lib/features/tools/presentation/pages/tool_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';

class ToolDetailPage extends StatelessWidget {
  final Tool tool;
  final Function(BuildContext, Tool) onInstall;
  final Function(BuildContext, Tool) onUninstall;

  const ToolDetailPage({
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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          tool.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.3),
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
                                color: Colors.black.withOpacity(0.08),
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
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                          width: 72,
                                          height: 72,
                                          child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          width: 72,
                                          height: 72,
                                          color: theme
                                              .colorScheme
                                              .surfaceContainerHighest,
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
                                    color: theme.colorScheme.primaryContainer
                                        .withOpacity(0.8),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'v${tool.version}',
                                    style: TextStyle(
                                      color: theme
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ),
                                if (tool.hasUpdate) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 40,
                        child: isInstalled
                            ? OutlinedButton(
                                onPressed: () => onUninstall(context, tool),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: theme.colorScheme.error,
                                  side: BorderSide(
                                    color: theme.colorScheme.error.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
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
                                onPressed: () => onInstall(context, tool),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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
                ),
                const SizedBox(height: 32),

                if (tool.description != null &&
                    tool.description!.isNotEmpty) ...[
                  _buildSectionTitle(
                    theme,
                    'About this software',
                    Icons.info_outline_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildContentCard(
                    theme,
                    child: Text(
                      tool.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                if (tool.changelog != null && tool.changelog!.isNotEmpty) ...[
                  _buildSectionTitle(
                    theme,
                    'What\'s New & Changelog',
                    Icons.history_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildContentCard(
                    theme,
                    child: Text(
                      tool.changelog!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                if (tool.links.isNotEmpty) ...[
                  _buildSectionTitle(
                    theme,
                    'Resources & Links',
                    Icons.link_rounded,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: tool.links.entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) {
                          final key = entry.key;
                          final url = entry.value;
                          return ActionChip(
                            avatar: Icon(
                              _getIconForLinkKey(key),
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            label: Text(_formatLinkKeyLabel(key)),
                            onPressed: () async {
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                ],

                if (tool.tags.isNotEmpty) ...[
                  _buildSectionTitle(
                    theme,
                    'Categories & Tags',
                    Icons.tag_rounded,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tool.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withOpacity(
                              0.2,
                            ),
                          ),
                        ),
                        child: Text(
                          tag.trim(),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForLinkKey(String key) {
    switch (key.toLowerCase()) {
      case 'web':
        return Icons.language_rounded;
      case 'docs':
        return Icons.menu_book_rounded;
      case 'telegram':
        return Icons.send_rounded;
      case 'x':
      case 'twitter':
        return Icons.flutter_dash_rounded;
      case 'github':
        return Icons.code_rounded;
      case 'instagram':
        return Icons.camera_alt_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  String _formatLinkKeyLabel(String key) {
    switch (key.toLowerCase()) {
      case 'web':
        return 'Website';
      case 'docs':
        return 'Documentation';
      case 'telegram':
        return 'Telegram';
      case 'x':
        return 'X (Twitter)';
      case 'github':
        return 'GitHub';
      case 'instagram':
        return 'Instagram';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.25),
        ),
      ),
      child: child,
    );
  }
}
