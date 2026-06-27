import 'package:flutter/material.dart';
import 'package:datapack/models/tool_model.dart';
import 'package:datapack/pages/tool_detail_page.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: iconUrl != null && iconUrl.isNotEmpty
            ? CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(iconUrl),
                onBackgroundImageError: (exception, stackTrace) =>
                    debugPrint('Failed to load icon: $exception'),
                radius: 24,
              )
            : const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 24,
                child: Icon(Icons.build, color: Colors.white),
              ),
        title: Text(
          tool.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: ${tool.version}'),
            if (tool.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: tool.tags.map((tag) {
                    return Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 10)),
                      backgroundColor: Colors.blueGrey[50],
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            if (tool.isInstalled) {
              onUninstall(context, tool);
            } else {
              onInstall(context, tool);
            }
          },
          child: Text(tool.isInstalled ? 'Uninstall' : 'Install'),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ToolDetailPage(tool: tool)),
          );
        },
      ),
    );
  }
}
