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
      appBar: AppBar(
        title: Text(
            tool.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(
                          imageUrl: iconUrl ?? '',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              Container(
                                width: 120,
                                height: 120,
                                color: theme.colorScheme
                                    .surfaceContainerHighest,
                                child: const Icon(Icons.extension, size: 60),
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tool.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                          0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Version: ${tool.version}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (tool.description != null && tool.description!.isNotEmpty) ...[
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    tool.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (tool.changelog != null && tool.changelog!.isNotEmpty) ...[
              Text(
                'Changelog',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    tool.changelog!,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (tool.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tool.tags.map((tag) {
                  return Chip(
                    label: Text(tag.trim(), style: const TextStyle(
                        fontSize: 12)),
                    backgroundColor: theme.colorScheme.secondaryContainer
                        .withOpacity(0.6),
                    labelStyle: TextStyle(color: theme.colorScheme
                        .onSecondaryContainer),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}