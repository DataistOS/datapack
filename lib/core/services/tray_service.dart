// lib/core/services/tray_service.dart
import 'dart:io';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayService with TrayListener, WindowListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  Future<void> initTray() async {
    windowManager.addListener(this);
    trayManager.addListener(this);

    // تنظیم آیکون تری
    await trayManager.setIcon(
      Platform.isWindows ? 'assets/images/logo.ico' : 'assets/images/logo.png',
    );

    Menu menu = Menu(
      items: [
        MenuItem(key: 'show_window', label: 'Open Datapack'),
        MenuItem.separator(),
        MenuItem(key: 'exit_app', label: 'Quit'),
      ],
    );
    await trayManager.setContextMenu(menu);
    await trayManager.setToolTip('Datapack Package Manager');
  }

  @override
  void onTrayIconMouseDown() async {
    if (await windowManager.isVisible()) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      await windowManager.show();
      await windowManager.focus();
    } else if (menuItem.key == 'exit_app') {
      await windowManager.destroy();
    }
  }

  @override
  void onWindowClose() async {
    bool isPrevent = await windowManager.isPreventClose();
    if (isPrevent) {
      await windowManager.hide();
    }
  }
}
