import 'package:flutter/material.dart';
import 'package:datapack/models/tool_model.dart';

class ToolDetailPage extends StatefulWidget {
  final Tool tool;

  const ToolDetailPage({super.key, required this.tool});

  @override
  State<ToolDetailPage> createState() => _ToolDetailPageState();
}

class _ToolDetailPageState extends State<ToolDetailPage> {
  late Tool _currentTool;

  @override
  void initState() {
    super.initState();
    _currentTool = widget.tool;
  }

  @override
  Widget build(BuildContext context) {

    final String? iconUrl = _currentTool.icon;

    return Scaffold(
      appBar: AppBar(title: Text(_currentTool.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (iconUrl != null && iconUrl.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        iconUrl,
                        width: 150,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 150),
                      ),
                    ),
                  ),
                ),
              Text(
                _currentTool.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Version: ${_currentTool.version}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (_currentTool.description != null &&
                  _currentTool.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_currentTool.description!),
                    const SizedBox(height: 16),
                  ],
                ),
              if (_currentTool.changelog != null &&
                  _currentTool.changelog!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Changelog:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_currentTool.changelog!),
                    const SizedBox(height: 16),
                  ],
                ),
              if (_currentTool.tags.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _currentTool.tags.map((tag) {
                        return Chip(
                          label: Text(
                            tag.trim(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blueGrey[50],
                          padding: const EdgeInsets.all(4),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
