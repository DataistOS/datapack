// lib/features/tools/presentation/pages/tool_detail/tool_detail_page.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/data/models/tool_model.dart';
import 'package:datapack/features/tools/data/models/tool_source_model.dart';
import 'package:datapack/features/tools/data/sources/tool_source_resolver.dart';
import 'widgets/tool_header_card.dart';
import 'widgets/tool_info_section.dart';
import 'widgets/tool_links_section.dart';
import 'widgets/tool_tags_section.dart';

class ToolDetailPage extends StatefulWidget {
  final Tool tool;
  final ToolSourceResolver? sourceResolver;
  final Function(BuildContext, Tool) onInstall;
  final Function(BuildContext, Tool) onUninstall;
  final Function(BuildContext, Tool, ToolSource)? onInstallWithSource;

  const ToolDetailPage({
    super.key,
    required this.tool,
    this.sourceResolver,
    required this.onInstall,
    required this.onUninstall,
    this.onInstallWithSource,
  });

  @override
  State<ToolDetailPage> createState() => _ToolDetailPageState();
}

class _ToolDetailPageState extends State<ToolDetailPage> {
  late Tool _currentTool;
  late ToolSource _selectedSource;

  @override
  void initState() {
    super.initState();
    _currentTool = widget.tool;
    _selectedSource = _currentTool.activeSource;
    _loadResolvedSources();
  }

  Future<void> _loadResolvedSources() async {
    final resolver = widget.sourceResolver;
    if (resolver == null) return;

    final resolved = await resolver.resolveAllSources(_currentTool);
    if (!mounted || resolved.isEmpty) return;

    setState(() {
      _currentTool = _currentTool.copyWith(sources: resolved);
      _selectedSource = resolved.firstWhere(
        (s) => s.id == _selectedSource.id,
        orElse: () => resolved.first,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _currentTool.name,
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
                  tool: _currentTool,
                  selectedSource: _selectedSource,
                  onSourceChanged: (source) {
                    setState(() {
                      _selectedSource = source;
                    });
                  },
                  onInstall: widget.onInstall,
                  onUninstall: widget.onUninstall,
                  onInstallWithSource: widget.onInstallWithSource,
                ),
                const SizedBox(height: 32),

                ToolInfoSection(tool: _currentTool),
                const SizedBox(height: 28),

                ToolLinksSection(links: _currentTool.links),
                const SizedBox(height: 28),

                ToolTagsSection(tags: _currentTool.tags),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
