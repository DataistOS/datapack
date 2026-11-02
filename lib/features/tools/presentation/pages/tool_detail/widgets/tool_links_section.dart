// lib/features/tools/presentation/pages/tool_detail/widgets/tool_links_section.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolLinksSection extends StatelessWidget {
  final Map<String, String> links;

  const ToolLinksSection({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (links.isEmpty || links.values.every((v) => v.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Resources & Links', Icons.link_rounded),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: links.entries.where((entry) => entry.value.isNotEmpty).map((
            entry,
          ) {
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
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            );
          }).toList(),
        ),
      ],
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
}
