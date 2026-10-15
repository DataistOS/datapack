// lib/core/platform/system_commands.dart

import 'dart:io';
import 'package:datapack/core/platform/platform_detector.dart';

class SystemCommands {
  static Future<bool> isToolInstalled(String packageName) async {
    if (!PlatformDetector.isLinux) {
      return false;
    }

    try {
      final result = await Process.run('dpkg', ['-s', packageName]);
      return result.exitCode == 0;
    } catch (e) {
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
      return null;
    }
  }

  static Future<ProcessResult> installDebPackage(String filePath) async {
    return await Process.run(
      'sudo',
      ['apt-get', 'install', '-y', filePath],
      environment: {'DEBIAN_FRONTEND': 'noninteractive'},
    );
  }

  static Future<ProcessResult> removePackage(String packageName) async {
    return await Process.run('sudo', [
      'apt-get',
      'remove',
      '-y',
      packageName,
    ]);
  }
}