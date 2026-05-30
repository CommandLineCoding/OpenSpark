import 'package:flutter/material.dart';
import '../theme_extensions.dart';

class TerminalCard extends StatelessWidget {
  final Widget child;

  const TerminalCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.terminalColors.tertiary.withValues(alpha: 0.4),
        border: Border.all(color: context.terminalColors.secondary, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14, bottom: 10),
            child: Row(
              children: [
                _buildDot(const Color(0xFFFF5F56)),
                const SizedBox(width: 6),
                _buildDot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _buildDot(context.terminalColors.primary),
              ],
            ),
          ),
          const Divider(color: Color(0xFF21262D), height: 1),
          Padding(padding: const EdgeInsets.all(24.0), child: child),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
