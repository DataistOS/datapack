// lib/features/tools/presentation/widgets/sort_filter_bar.dart

import 'package:flutter/material.dart';

enum SortOption { nameAsc, nameDesc, versionAsc, versionDesc, tagsAsc }

class SortFilterBar extends StatelessWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption?> onOptionChanged;

  const SortFilterBar({
    super.key,
    required this.selectedOption,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownMenu<SortOption>(
            initialSelection: selectedOption,
            onSelected: onOptionChanged,
            dropdownMenuEntries: const <DropdownMenuEntry<SortOption>>[
              DropdownMenuEntry<SortOption>(
                value: SortOption.tagsAsc,
                label: 'Tags (A-Z)',
              ),
              DropdownMenuEntry<SortOption>(
                value: SortOption.nameAsc,
                label: 'Name (A-Z)',
              ),
              DropdownMenuEntry<SortOption>(
                value: SortOption.nameDesc,
                label: 'Name (Z-A)',
              ),
              DropdownMenuEntry<SortOption>(
                value: SortOption.versionAsc,
                label: 'Version (Oldest)',
              ),
              DropdownMenuEntry<SortOption>(
                value: SortOption.versionDesc,
                label: 'Version (Newest)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}