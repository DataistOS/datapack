// lib/core/platform/platform_detector.dart

import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformDetector {
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isWeb => kIsWeb;

  static String getOperatingSystemName() {
    if (kIsWeb) return 'Web';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }
}