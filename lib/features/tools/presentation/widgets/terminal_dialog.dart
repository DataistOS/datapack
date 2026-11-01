// lib/features/tools/presentation/widgets/terminal_dialog.dart
import 'package:flutter/material.dart';

class TerminalDialog extends StatefulWidget {
  final String title;
  final Future<bool> Function(Function(String log) onLog) action;

  const TerminalDialog({super.key, required this.title, required this.action});

  @override
  State<TerminalDialog> createState() => _TerminalDialogState();
}

class _TerminalDialogState extends State<TerminalDialog> {
  final List<String> _logs = [];
  bool _isFinished = false;
  bool _isSuccess = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _runAction();
  }

  void _runAction() async {
    _appendLog('Initializing process for ${widget.title}...');
    try {
      final success = await widget.action((log) {
        _appendLog(log);
      });
      setState(() {
        _isFinished = true;
        _isSuccess = success;
        _appendLog(
          success ? 'Process completed successfully.' : 'Process failed.',
        );
      });
    } catch (e) {
      setState(() {
        _isFinished = true;
        _isSuccess = false;
        _appendLog('Error: $e');
      });
    }
  }

  void _appendLog(String log) {
    if (mounted) {
      setState(() {
        _logs.add(log);
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            _isFinished
                ? (_isSuccess ? Icons.check_circle : Icons.error)
                : Icons.terminal,
            color: _isFinished
                ? (_isSuccess ? Colors.green : Colors.red)
                : Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(widget.title),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 300,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  _logs[index],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.greenAccent,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        if (_isFinished)
          FilledButton(
            onPressed: () => Navigator.pop(context, _isSuccess),
            child: const Text('Close'),
          )
        else
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}
