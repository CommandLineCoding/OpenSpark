import 'package:flutter/material.dart';
import '../theme_extensions.dart';

class TerminalBlock extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const TerminalBlock({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.terminalColors.tertiary.withValues(alpha: 0.3),
        border: Border.all(color: context.terminalColors.secondary, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
