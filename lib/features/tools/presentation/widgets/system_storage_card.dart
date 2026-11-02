// lib/features/tools/presentation/widgets/system_storage_card.dart
import 'package:flutter/material.dart';
import 'package:datapack/core/platform/system_commands.dart';

class SystemStorageCard extends StatefulWidget {
  const SystemStorageCard({super.key});

  @override
  State<SystemStorageCard> createState() => _SystemStorageCardState();
}

class _SystemStorageCardState extends State<SystemStorageCard> {
  late Future<DiskInfo> _diskSpaceFuture;

  @override
  void initState() {
    super.initState();
    _diskSpaceFuture = SystemCommands.getDiskSpaceInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<DiskInfo>(
      future: _diskSpaceFuture,
      builder: (context, snapshot) {
        double totalSpaceGb = 500.0;
        double usedSpaceGb = 328.5;

        if (snapshot.hasData) {
          totalSpaceGb = snapshot.data!['total'] ?? 500.0;
          usedSpaceGb = snapshot.data!['used'] ?? 328.5;
        }

        final double appsSpace = usedSpaceGb * 0.4;
        final double systemSpace = usedSpaceGb * 0.3;
        final double cacheSpace = usedSpaceGb * 0.2;
        final double otherSpace =
            usedSpaceGb - (appsSpace + systemSpace + cacheSpace);

        final List<StorageSegment> segments = [
          StorageSegment(
            title: 'Apps',
            sizeGb: appsSpace,
            color: const Color(0xFFFF3B30),
          ),
          StorageSegment(
            title: 'System',
            sizeGb: systemSpace,
            color: const Color(0xFF8E8E93),
          ),
          StorageSegment(
            title: 'Cache',
            sizeGb: cacheSpace,
            color: const Color(0xFFFFCC00),
          ),
          StorageSegment(
            title: 'Other',
            sizeGb: otherSpace > 0 ? otherSpace : 0,
            color: const Color(0xFFAF52DE),
          ),
        ];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storage_rounded,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'System Storage',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          '${usedSpaceGb.toStringAsFixed(1)} GB of ${totalSpaceGb.toStringAsFixed(0)} GB Used',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: SizedBox(
                  height: 10,
                  child: Row(
                    children: segments.map((segment) {
                      final flexValue = ((segment.sizeGb / totalSpaceGb) * 1000)
                          .round();
                      return Expanded(
                        flex: flexValue > 0 ? flexValue : 1,
                        child: Container(color: segment.color),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12.0,
                runSpacing: 4.0,
                children: segments.map((segment) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: segment.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${segment.title} (${segment.sizeGb.toStringAsFixed(1)}G)',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StorageSegment {
  final String title;
  final double sizeGb;
  final Color color;

  const StorageSegment({
    required this.title,
    required this.sizeGb,
    required this.color,
  });
}
