import 'package:flutter/material.dart';
import '../../design_system/theme_extensions.dart';

class SessionTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const SessionTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border.all(color: context.terminalColors.secondary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(context, index: 0, label: 'INITIATE_SESSION'),
          ),
          Expanded(child: _buildTab(context, index: 1, label: 'CREATE_NODE')),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required int index,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.terminalColors.secondary.withValues(alpha: 0.4)
              : Colors.transparent,
          border: isSelected
              ? Border.all(color: context.terminalColors.secondary)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: context.terminalText.labelLarge?.copyWith(
              fontSize: 12,
              color: isSelected
                  ? context.terminalColors.primary
                  : context.terminalColors.secondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
