// lib/features/tools/presentation/pages/tool_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';

class ToolDetailPage extends StatelessWidget {
  final Tool tool;

  const ToolDetailPage({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final String? iconUrl = tool.icon;
    final theme = Theme.of(context);

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
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'tool-icon-${tool.name}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CachedNetworkImage(
                              imageUrl: iconUrl ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 100,
                                height: 100,
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.extension_rounded,
                                  size: 50,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tool.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Version: ${tool.version}',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                if (tool.description != null &&
                    tool.description!.isNotEmpty) ...[
                  _buildSectionTitle(
                    theme,
                    'Description',
                    Icons.description_outlined,
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
                  _buildSectionTitle(theme, 'Changelog', Icons.history_rounded),
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

                if (tool.tags.isNotEmpty) ...[
                  _buildSectionTitle(theme, 'Tags', Icons.tag_rounded),
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
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withOpacity(
                              0.3,
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
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: child,
    );
  }
}
