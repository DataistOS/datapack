// lib/features/tools/presentation/pages/tool_detail/widgets/tool_info_section.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/services/github_doc_service.dart';

class ToolInfoSection extends StatefulWidget {
  final Tool tool;

  const ToolInfoSection({super.key, required this.tool});

  @override
  State<ToolInfoSection> createState() => _ToolInfoSectionState();
}

class _ToolInfoSectionState extends State<ToolInfoSection> {
  bool _isDescExpanded = false;
  bool _isChangelogExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          'About this software',
          Icons.info_outline_rounded,
        ),
        const SizedBox(height: 10),
        _buildContentCard(
          theme,
          child: FutureBuilder<String?>(
            future: _fetchRemoteDescription(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              String? content = snapshot.data;
              if (snapshot.hasError ||
                  content == null ||
                  content.isEmpty ||
                  content.startsWith('Failed') ||
                  content.startsWith('Network error')) {
                content = widget.tool.description;
              }

              if (content == null || content.isEmpty) {
                return const Text('No description available.');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _isDescExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 180),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Text(
                              content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.surface.withOpacity(
                                        0.0,
                                      ),
                                      theme.colorScheme.surfaceContainerHighest
                                          .withOpacity(0.9),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: SizedBox(
                      width: double.infinity,
                      child: Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isDescExpanded = !_isDescExpanded;
                        });
                      },
                      icon: Icon(
                        _isDescExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _isDescExpanded ? 'Show Less' : 'Show More',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 28),

        _buildSectionTitle(
          theme,
          'What\'s New & Changelog',
          Icons.history_rounded,
        ),
        const SizedBox(height: 10),
        _buildContentCard(
          theme,
          child: FutureBuilder<String?>(
            future: _fetchRemoteChangelog(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              String? content = snapshot.data;
              if (snapshot.hasError ||
                  content == null ||
                  content.isEmpty ||
                  content.startsWith('Failed') ||
                  content.startsWith('Network error')) {
                content = widget.tool.changelog;
              }

              if (content == null || content.isEmpty) {
                return const Text('No changelog available.');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _isChangelogExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 180),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Text(
                              content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.surface.withOpacity(
                                        0.0,
                                      ),
                                      theme.colorScheme.surfaceContainerHighest
                                          .withOpacity(0.9),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: SizedBox(
                      width: double.infinity,
                      child: Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isChangelogExpanded = !_isChangelogExpanded;
                        });
                      },
                      icon: Icon(
                        _isChangelogExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _isChangelogExpanded ? 'Show Less' : 'Show More',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<String?> _fetchRemoteDescription() async {
    final docsUrl = widget.tool.links['docs'];
    if (docsUrl == null || docsUrl.isEmpty) {
      return null;
    }

    String targetUrl = docsUrl;
    if (targetUrl.endsWith('.html')) {
      targetUrl = targetUrl.replaceAll('.html', '.md');
    }

    return await GithubDocService.fetchRemoteContent(targetUrl);
  }

  Future<String?> _fetchRemoteChangelog() async {
    // آدرس فایل خام چنج‌لاگ در مخزن گیت‌هاب پروژه
    const rawChangelogUrl =
        'https://raw.githubusercontent.com/DataistOS/datapack/heuristic/CHANGELOG.md';
    return await GithubDocService.fetchRemoteContent(rawChangelogUrl);
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
