import 'package:flutter/material.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';

class SparkItem {
  final String title;
  final String id;
  final String tag;
  final String timeAgo;
  final IconData icon;

  const SparkItem({
    required this.title,
    required this.id,
    required this.tag,
    required this.timeAgo,
    required this.icon,
  });
}

class SparkCard extends StatelessWidget {
  final SparkItem item;
  final VoidCallback onInspect;

  const SparkCard({super.key, required this.item, required this.onInspect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TerminalBlock(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon, Title, and System Category Tag
            Row(
              children: [
                Icon(
                  item.icon,
                  color: context.terminalColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: context.terminalText.bodyMedium?.copyWith(
                      fontFamily: 'JetBrains Mono',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.terminalColors.secondary.withValues(
                      alpha: 0.6,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.tag,
                    style: context.terminalText.labelLarge?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Row 2: Sub-identifier path
            Text(
              'ID: ${item.id}',
              style: context.terminalText.labelLarge?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 14),

            // Row 3: Visual Log Stream Placeholder Delineator
            Text(
              '- - - - - - - - - - - - - - - - - - -',
              style: TextStyle(
                color: context.terminalColors.secondary.withValues(alpha: 0.5),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFF21262D), height: 1),
            const SizedBox(height: 12),

            // Row 4: Card Footer Action & Metatime stamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: context.terminalColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.timeAgo,
                      style: context.terminalText.labelLarge?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onInspect,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F242C),
                      border: Border.all(
                        color: context.terminalColors.secondary,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'INSPECT',
                      style: context.terminalText.labelLarge?.copyWith(
                        color: context.terminalColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
