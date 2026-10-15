// lib/features/tools/presentation/widgets/refresh_button.dart

import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;

  const RefreshButton({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh);
  }
}