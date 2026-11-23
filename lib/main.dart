// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:datapack/core/services/logging_service.dart';
import 'package:datapack/core/services/settings_service.dart';
import 'package:datapack/features/tools/data/sources/github_source_provider.dart';
import 'package:datapack/features/tools/data/sources/upupa_source_provider.dart';
import 'package:datapack/features/tools/data/sources/tool_source_resolver.dart';
import 'package:datapack/features/tools/presentation/providers/tool_provider.dart';
import 'package:datapack/features/tools/presentation/providers/workspace_provider.dart';
import 'package:datapack/features/tools/presentation/pages/tool_list_page.dart';
import 'package:datapack/shared/pages/welcome_page.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}

  try {
    await LoggingService.init();
    await LoggingService.log('Datapack application started successfully.');
  } catch (_) {}

  final savedDarkMode = await SettingsService.getDarkMode();
  themeNotifier.value = savedDarkMode;

  final isFirstRun = await SettingsService.isFirstRun();

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({super.key, required this.isFirstRun});

  ToolSourceResolver _buildSourceResolver() {
    return ToolSourceResolver(
      providers: [GitHubSourceProvider(), UpUpaSourceProvider()],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sourceResolver = _buildSourceResolver();

    return MultiProvider(
      providers: [
        Provider<ToolSourceResolver>.value(value: sourceResolver),
        ChangeNotifierProvider(
          create: (_) => ToolProvider(sourceResolver: sourceResolver),
        ),
        ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
      ],
      child: ValueListenableBuilder<bool>(
        valueListenable: themeNotifier,
        builder: (context, isDark, child) {
          return MaterialApp(
            title: 'Datapack',
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            home: isFirstRun ? const WelcomePage() : const ToolListPage(),
          );
        },
      ),
    );
  }
}
