// lib/core/services/logging_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggingService {
  static File? _logFile;

  static Future<void> init() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final dateStr = DateTime.now().toIso8601String().split('T')[0];
      _logFile = File('${logDir.path}/datapack_$dateStr.log');

      if (!await _logFile!.exists()) {
        await _logFile!.create();
        await _logFile!.writeAsString(
          '--- Datapack Log Session Started at ${DateTime.now()} ---\n',
        );
      }
    } catch (e) {
      print('Failed to initialize logging service: $e');
    }
  }

  static Future<void> log(String message, {String level = 'INFO'}) async {
    try {
      if (_logFile == null) {
        await init();
      }

      final timestamp = DateTime.now().toIso8601String();
      final logEntry = '[$timestamp] [$level] $message\n';

      await _logFile?.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Failed to write log: $e');
    }
  }

  static Future<String> getTodayLogs() async {
    try {
      if (_logFile != null && await _logFile!.exists()) {
        return await _logFile!.readAsString();
      }
    } catch (e) {
      print('Failed to read logs: $e');
    }
    return 'No logs available.';
  }

  static Future<String?> getLogFilePath() async {
    return _logFile?.path;
  }
}
