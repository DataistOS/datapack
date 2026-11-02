// lib/core/platform/system_commands.dart
import 'dart:io';
import 'package:datapack/core/platform/platform_detector.dart';
import 'package:datapack/core/services/logging_service.dart';

typedef DiskInfo = Map<String, double>;

class SystemCommands {
  static Future<bool> isToolInstalled(String packageName) async {
    if (!PlatformDetector.isLinux) {
      return false;
    }

    try {
      final result = await Process.run('dpkg', ['-s', packageName]);
      return result.exitCode == 0;
    } catch (e) {
      await LoggingService.log(
        'Error checking if tool $packageName is installed: $e',
        level: 'ERROR',
      );
      return false;
    }
  }

  static Future<String?> getInstalledVersion(String packageName) async {
    if (!PlatformDetector.isLinux) return null;

    try {
      final result = await Process.run('dpkg-query', [
        '-f',
        r'${Version}',
        '-W',
        packageName,
      ]);
      if (result.exitCode == 0 && result.stdout.isNotEmpty) {
        return (result.stdout as String).trim();
      }
      return null;
    } catch (e) {
      await LoggingService.log(
        'Error getting installed version for $packageName: $e',
        level: 'ERROR',
      );
      return null;
    }
  }

  static Future<ProcessResult> installDebPackage(String filePath) async {
    try {
      await LoggingService.log(
        'Executing installation for deb package: $filePath',
      );
      return await Process.run(
        'sudo',
        ['apt-get', 'install', '-y', filePath],
        environment: {'DEBIAN_FRONTEND': 'noninteractive'},
      );
    } catch (e) {
      await LoggingService.log(
        'Exception during package installation: $e',
        level: 'ERROR',
      );
      rethrow;
    }
  }

  static Future<ProcessResult> removePackage(String packageName) async {
    try {
      await LoggingService.log('Executing removal for package: $packageName');
      return await Process.run('sudo', [
        'apt-get',
        'remove',
        '-y',
        packageName,
      ]);
    } catch (e) {
      await LoggingService.log(
        'Exception during package removal: $e',
        level: 'ERROR',
      );
      rethrow;
    }
  }

  static Future<DiskInfo> getDiskSpaceInfo() async {
    if (!PlatformDetector.isLinux) {
      return {'total': 500.0, 'used': 328.5, 'free': 171.5};
    }

    try {
      final result = await Process.run('df', ['--output=size,used', '/']);
      if (result.exitCode == 0) {
        final lines = (result.stdout as String).trim().split('\n');
        if (lines.length >= 2) {
          final values = lines[1].trim().split(RegExp(r'\s+'));
          if (values.length >= 2) {
            double totalKb = double.tryParse(values[0]) ?? 0;
            double usedKb = double.tryParse(values[1]) ?? 0;

            double totalGb = totalKb / (1024 * 1024);
            double usedGb = usedKb / (1024 * 1024);

            return {'total': totalGb, 'used': usedGb, 'free': totalGb - usedGb};
          }
        }
      }
    } catch (e) {
      await LoggingService.log(
        'Error getting disk space info: $e',
        level: 'ERROR',
      );
    }

    return {'total': 500.0, 'used': 328.5, 'free': 171.5};
  }
}
