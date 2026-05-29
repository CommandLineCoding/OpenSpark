import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../sparks/sparks_feed_screen.dart';
import 'navigation_provider.dart';
import '../profile/profile_screen.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNavIndex = ref.watch(navigationIndexProvider);

    final List<Widget> systemScreens = [
      const SparksFeedScreen(), // Tab 0: Primary Mainframe Focus
      const _PlaceholderScreen(
        title: '~/TERMINAL_MONITOR_DASHBOARD',
      ), // Tab 1: Subdued Placeholder
      const _PlaceholderScreen(
        title: '~/COLLABORATORS_NETWORK_MATRIX',
      ), // Tab 2: Subdued Placeholder
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      body: IndexedStack(index: currentNavIndex, children: systemScreens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF21262D), width: 1)),
          color: Color(0xFF001117),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                ref,
                index: 0,
                label: 'Blueprints',
                icon: Icons.architecture_rounded,
              ),
              _buildNavItem(
                context,
                ref,
                index: 1,
                label: 'Terminal',
                icon: Icons.terminal_rounded,
              ),
              _buildNavItem(
                context,
                ref,
                index: 2,
                label: 'Collab',
                icon: Icons.people_outline_rounded,
              ),
              _buildNavItem(
                context,
                ref,
                index: 3,
                label: 'Profile',
                icon: Icons.account_circle_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required int index,
    required String label,
    required IconData icon,
  }) {
    final activeIndexNotifier = ref.read(navigationIndexProvider.notifier);
    final isSelected = ref.watch(navigationIndexProvider) == index;

    return GestureDetector(
      onTap: () => activeIndexNotifier.state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.terminalColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.black
                  : context.terminalColors.secondary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.terminalText.labelLarge?.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.black
                    : context.terminalColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<TerminalColors>();
    return Scaffold(
      backgroundColor: colors?.neutralBg ?? const Color(0xFF0D1117),
      body: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: colors?.primary ?? const Color(0xFF39D353),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
