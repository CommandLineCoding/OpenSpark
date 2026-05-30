import 'package:flutter/material.dart';
import '../theme_extensions.dart';

class TerminalTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TerminalTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              prefixIcon,
              size: 14,
              color: context.terminalColors.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(label, style: context.terminalText.labelLarge),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          cursorColor: context.terminalColors.primary,
          style: context.terminalText.bodyMedium?.copyWith(
            fontFamily: 'JetBrains Mono',
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: context.terminalColors.secondary.withValues(alpha: 0.8),
            ),
            filled: true,
            fillColor: const Color(0xFF0D1117),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.terminalColors.secondary),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.terminalColors.primary),
              borderRadius: BorderRadius.circular(4),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
