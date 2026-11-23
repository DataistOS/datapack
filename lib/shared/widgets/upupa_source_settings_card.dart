// lib/shared/widgets/upupa_source_settings_card.dart
import 'package:flutter/material.dart';
import 'package:datapack/core/services/settings_service.dart';

class UpupaSourceSettingsCard extends StatefulWidget {
  final bool initialEnabled;
  final String? initialServerUrl;
  final String initialCollectionName;
  final ValueChanged<bool>? onEnabledChanged;

  const UpupaSourceSettingsCard({
    super.key,
    required this.initialEnabled,
    required this.initialServerUrl,
    required this.initialCollectionName,
    this.onEnabledChanged,
  });

  @override
  State<UpupaSourceSettingsCard> createState() =>
      _UpupaSourceSettingsCardState();
}

class _UpupaSourceSettingsCardState extends State<UpupaSourceSettingsCard> {
  late bool _isEnabled;
  late final TextEditingController _urlController;
  late final TextEditingController _collectionController;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialEnabled;
    _urlController = TextEditingController(text: widget.initialServerUrl ?? '');
    _collectionController = TextEditingController(
      text: widget.initialCollectionName,
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _collectionController.dispose();
    super.dispose();
  }

  String? _validateUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return 'آدرس معتبر وارد کنید (مثال: http://localhost:8090)';
    }
    return null;
  }

  Future<void> _saveConfig() async {
    final error = _validateUrl(_urlController.text);
    setState(() {
      _errorText = error;
    });
    if (error != null) return;

    setState(() => _isSaving = true);
    try {
      await SettingsService.setUpupaServerUrl(_urlController.text);
      await SettingsService.setUpupaCollectionName(_collectionController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تنظیمات سرور هدهد (UpUpa) ذخیره شد'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SwitchListTile(
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.dns_outlined, color: theme.colorScheme.primary),
          ),
          title: const Text(
            'UpUpa Local / Network Source',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'Fetch and install packages from a local or LAN UpUpa server',
          ),
          value: _isEnabled,
          onChanged: (value) async {
            setState(() => _isEnabled = value);
            await SettingsService.setUpupaSourceEnabled(value);
            widget.onEnabledChanged?.call(value);
          },
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                enabled: _isEnabled,
                decoration: InputDecoration(
                  labelText: 'UpUpa Server URL',
                  hintText: 'http://localhost:8090',
                  errorText: _errorText,
                  prefixIcon: const Icon(Icons.link_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _collectionController,
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                        labelText: 'Collection Name',
                        hintText: SettingsService.defaultUpupaCollection,
                        prefixIcon: const Icon(Icons.folder_copy_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isEnabled && !_isSaving ? _saveConfig : null,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
