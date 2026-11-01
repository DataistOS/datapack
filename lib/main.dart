// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';
import 'package:datapack/core/services/logging_service.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/presentation/pages/tool_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(950, 700),
    minimumSize: Size(700, 500),
    center: true,
    title: 'Datapack Toolbox',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    try {
      if (Platform.isLinux || Platform.isWindows) {}
    } catch (_) {}
  });

  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}

  await LoggingService.init();
  await LoggingService.log('Datapack application started successfully.');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToolProvider()..fetchTools(),
      child: MaterialApp(
        title: 'Datapack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Vazir',
        ),
        home: const ToolListPage(),
      ),
    );
  }
}
