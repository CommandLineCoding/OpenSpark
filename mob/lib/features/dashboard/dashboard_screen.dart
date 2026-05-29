import 'package:flutter/material.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'spark_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  // Static telemetry list feed values
  final List<SparkItem> _sparks = const [
    SparkItem(
      title: 'DataPipeline_v2',
      id: 'SPK-092A',
      tag: 'ETL',
      timeAgo: '2m ago',
      icon: Icons.flash_on_rounded,
    ),
    SparkItem(
      title: 'Auth_Microservice',
      id: 'SPK-088B',
      tag: 'SEC',
      timeAgo: '15m ago',
      icon: Icons.lan_outlined,
    ),
    SparkItem(
      title: 'Cache_Layer_Opt',
      id: 'SPK-071C',
      tag: 'INFRA',
      timeAgo: '1h ago',
      icon: Icons.layers_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,

      // Top Mainframe Header Bar
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'OpenSpark',
          style: TextStyle(
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
              ),
            ),
          ),
        ],
      ),

      // Scrollable Monitoring Feed Area
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Upper Metrics Telemetry Box
          TerminalBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Sparks',
                      style: context.terminalText.headlineMedium?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: context.terminalColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'SYS_ONLINE',
                          style: context.terminalText.labelLarge?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'ACTIVE_NODES',
                        value: '124',
                        valueColor: context.terminalColors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'ERRORS',
                        value: '0',
                        valueColor: const Color(0xFFFF5F56),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stream Sparks List View
          ..._sparks.map(
            (spark) => SparkCard(
              item: spark,
              onInspect: () {
                // Handle inspection terminal execution routine
              },
            ),
          ),
        ],
      ),

      // Sleek Terminal System Bottom Navigation Bar
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
                0,
                label: 'Blueprints',
                icon: Icons.architecture_rounded,
              ),
              _buildNavItem(1, label: 'Terminal', icon: Icons.terminal_rounded),
              _buildNavItem(
                2,
                label: 'Collab',
                icon: Icons.people_outline_rounded,
              ),
              _buildNavItem(
                3,
                label: 'Profile',
                icon: Icons.account_circle_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border.all(
          color: context.terminalColors.secondary.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.terminalText.labelLarge?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index, {
    required String label,
    required IconData icon,
  }) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
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
