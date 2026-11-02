// lib/core/services/tray_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  Future<void> initTray() async {
    try {
      trayManager.addListener(this);

      final iconPath = Platform.isWindows
          ? 'assets/images/logo.ico'
          : 'assets/images/logo.png';

      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('Datapack Package Manager');

      Menu menu = Menu(
        items: [
          MenuItem(key: 'show_window', label: 'Open Datapack'),
          MenuItem.separator(),
          MenuItem(key: 'exit_app', label: 'Quit'),
        ],
      );
      await trayManager.setContextMenu(menu);
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
