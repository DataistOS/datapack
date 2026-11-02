// lib/features/tools/presentation/widgets/workspace_banner.dart
import 'package:flutter/material.dart';

class WorkspaceBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> sampleIcons;
  final IconData? bannerIcon;

  const WorkspaceBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.sampleIcons = const [],
    this.bannerIcon = Icons.workspaces_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1B4B), // Indigo Dark
            Color(0xFF311045), // Deep Purple
            Color(0xFF4C1D95), // Vibrant Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.isNotEmpty ? title : 'Choose Your Industry Workspace',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle.isNotEmpty
                      ? subtitle
                      : 'Datapack provides curated tool stacks tailored to your professional domain, all in one place',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          if (sampleIcons.isNotEmpty) ...[
            Row(
              children: sampleIcons.map((iconPath) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(8),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                );
              }).toList(),
            ),
          ] else if (bannerIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                bannerIcon,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
