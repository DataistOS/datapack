import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;

  const CustomAppBar({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Datapack Manager'),
      actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
