// lib/features/tools/presentation/pages/tool_detail/tool_detail_page.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'widgets/tool_header_card.dart';
import 'widgets/tool_info_section.dart';
import 'widgets/tool_links_section.dart';
import 'widgets/tool_tags_section.dart';

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
          constraints: const BoxConstraints(maxWidth: 750),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToolHeaderCard(
                  tool: tool,
                  onInstall: onInstall,
                  onUninstall: onUninstall,
                ),
                const SizedBox(height: 32),

                ToolInfoSection(tool: tool),
                const SizedBox(height: 28),

                ToolLinksSection(links: tool.links),
                const SizedBox(height: 28),

                ToolTagsSection(tags: tool.tags),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
