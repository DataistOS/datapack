// lib/core/services/tray_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  bool _isInitialized = false;

  Future<void> initTray() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      trayManager.addListener(this);

      final iconPath = Platform.isWindows
          ? 'assets/images/logo.ico'
          : 'assets/images/logo.png';

      try {
        await trayManager.setIcon(iconPath);
      } catch (e) {
        debugPrint('Tray setIcon warning: $e');
      }

      if (!Platform.isLinux) {
        try {
          await trayManager.setToolTip('Datapack Package Manager');
        } catch (e) {
          debugPrint('Tray setToolTip warning: $e');
        }
      }

      try {
        final Menu menu = Menu(
          items: [
            MenuItem(key: 'show_window', label: 'Open Datapack'),
            MenuItem.separator(),
            MenuItem(key: 'exit_app', label: 'Quit'),
          ],
        );
        await trayManager.setContextMenu(menu);
      } catch (e) {
        debugPrint('Tray setContextMenu warning: $e');
      }
    } catch (e) {
      debugPrint('Failed to initialize tray: $e');
    }
  }

  @override
  void onTrayIconMouseDown() async {
    try {
      await trayManager.popUpContextMenu();
    } catch (e) {
      debugPrint('Error on tray icon mouse down: $e');
    }
  }

  @override
  void onTrayIconRightMouseDown() async {
    try {
      await trayManager.popUpContextMenu();
    } catch (e) {
      debugPrint('Error on tray icon right click: $e');
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
    } else if (menuItem.key == 'exit_app') {
      exit(0);
    }
  }
}
