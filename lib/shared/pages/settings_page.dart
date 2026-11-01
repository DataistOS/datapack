// shared/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:datapack/core/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool isDark) onThemeChanged;

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = true;
  bool _autoCheckUpdate = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await SettingsService.getDarkMode();
    final autoCheck = await SettingsService.getAutoCheckUpdate();
    setState(() {
      _isDarkMode = isDark;
      _autoCheckUpdate = autoCheck;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              _buildSectionHeader(theme, 'Appearance', Icons.palette_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard(
                theme,
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.dark_mode_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: const Text(
                    'Dark Theme',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Use dark appearance across Datapack'),
                  value: _isDarkMode,
                  onChanged: (value) async {
                    setState(() {
                      _isDarkMode = value;
                    });
                    await SettingsService.setDarkMode(value);
                    widget.onThemeChanged(value);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(
                theme,
                'Application & Updates',
                Icons.system_update_outlined,
              ),
              const SizedBox(height: 12),
              _buildSettingsCard(
                theme,
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: const Text(
                    'Auto-check for Updates',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Check for new releases on GitHub automatically',
                  ),
                  value: _autoCheckUpdate,
                  onChanged: (value) async {
                    setState(() {
                      _autoCheckUpdate = value;
                    });
                    await SettingsService.setAutoCheckUpdate(value);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(theme, 'About', Icons.info_outline_rounded),
              const SizedBox(height: 12),
              _buildSettingsCard(
                theme,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.code_rounded,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  title: const Text(
                    'Datapack Package Manager',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Version 0.2.1 • Built with Flutter for Linux',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(ThemeData theme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}
