// lib/core/services/update_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class ReleaseInfo {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;

  const ReleaseInfo({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) {
    return ReleaseInfo(
      tagName: json['tag_name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      body: json['body']?.toString() ?? 'No changelog provided.',
      htmlUrl:
          json['html_url']?.toString() ??
          'https://github.com/DataistOS/datapack/releases',
    );
  }
}

class UpdateCheckResultModel {
  final bool hasUpdate;
  final String currentVersion;
  final ReleaseInfo release;

  const UpdateCheckResultModel({
    required this.hasUpdate,
    required this.currentVersion,
    required this.release,
  });
}

class UpdateService {
  static const String _githubReleaseUrl =
      'https://api.github.com/repos/DataistOS/datapack/releases/latest';

  static Future<UpdateCheckResultModel?> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(_githubReleaseUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Datapack-Linux-App',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final release = ReleaseInfo.fromJson(data);

        String remoteVersion = release.tagName.replaceAll(RegExp(r'^v'), '');
        String localVersion = currentVersion.replaceAll(RegExp(r'^v'), '');

        bool hasUpdate = _isNewerVersion(remoteVersion, localVersion);

        return UpdateCheckResultModel(
          hasUpdate: hasUpdate,
          currentVersion: currentVersion,
          release: release,
        );
      }
    } catch (e) {
      debugPrint('Failed to check for updates: $e');
    }
    return null;
  }

  static bool _isNewerVersion(String remote, String local) {
    try {
      List<int> remoteParts = remote
          .split('.')
          .map((e) => int.parse(e.replaceAll(RegExp(r'[^0-9]'), '')))
          .toList();
      List<int> localParts = local
          .split('.')
          .map((e) => int.parse(e.replaceAll(RegExp(r'[^0-9]'), '')))
          .toList();

      for (int i = 0; i < remoteParts.length; i++) {
        if (i >= localParts.length) return true;
        if (remoteParts[i] > localParts[i]) return true;
        if (remoteParts[i] < localParts[i]) return false;
      }
    } catch (_) {}
    return remote != local;
  }
}
