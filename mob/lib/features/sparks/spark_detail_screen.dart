import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'sparks_provider.dart';

class SparkDetailScreen extends ConsumerWidget {
  final SparkModel spark;

  const SparkDetailScreen({super.key, required this.spark});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ignited':
        return const Color(0xFF39D353);
      case 'sprout':
        return const Color(0xFFFFBD2E);
      default:
        return const Color(0xFF8B949E);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayId = spark.id.length > 4 ? spark.id.substring(0, 4) : spark.id;

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'OpenSpark',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(spark.authorAvatar),
          ),
          const SizedBox(width: 16),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module 1: Project Metadata Header Card
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          spark.title,
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B22),
                          border: Border.all(color: _getStatusColor(spark.status)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          spark.status.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            color: _getStatusColor(spark.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.0.0-blueprint • Created ${spark.timeAgo} by @${spark.authorName}',
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tech Stack Chips Array
                  if (spark.techStack.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: spark.techStack.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF30363D)),
                          ),
                          child: Text(
                            tech,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 11,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Module 2: AI Brainstorming Trigger & Pre-GitHub Metrics Bento
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.terminalColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Handshake hooks for future local/remote LLM orchestration
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: context.terminalColors.primary,
                            content: const Text(
                              'INITIALIZING_LLM_MAINFRAME: Context streaming setup coming next step.',
                              style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.psychology_outlined, size: 18, color: Colors.black),
                      label: Text(
                        'BRAINSTORM WITH THIS IDEA',
                        style: context.terminalText.labelLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF21262D), height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricRow(Icons.arrow_upward_rounded, '${spark.upvotes}', 'Upvotes ▲'),
                      _buildMetricRow(Icons.folder_shared_outlined, '4', 'Idea PRs'),
                      _buildMetricRow(Icons.analytics_outlined, '164', 'Telemetry Logs'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Module 3: CLI Inspect Command Block
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                border: Border.all(color: const Color(0xFF30363D)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    color: const Color(0xFF161B22),
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF8B949E)),
                        const SizedBox(width: 8),
                        Text(
                          'CLI Handshake Intercept',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context.terminalColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$ openspark inspect spark_${displayId.toLowerCase()}',
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 13,
                              color: Color(0xFF39D353),
                            ),
                          ),
                        ),
                        const Icon(Icons.content_copy_rounded, size: 16, color: Color(0xFF8B949E)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Module 4: High-Fidelity Active Markdown Rendering Panel
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.article_outlined, size: 16, color: Color(0xFF8B949E)),
                      const SizedBox(width: 8),
                      Text(
                        'RAW_SPECIFICATION.MD',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.terminalColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0xFF21262D)),
                  const SizedBox(height: 12),
                  
                  // Live custom text block generated dynamically from the active user payload
                  Text(
                    spark.description.isNotEmpty 
                        ? spark.description 
                        : 'No markdown schema compiled inside this node envelope.',
                    style: const TextStyle(
                      color: Color(0xFFC9D1D9), 
                      fontSize: 15, 
                      height: 1.5
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Terminal Modernism Code View Decorator Block
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D1117),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      border: Border(
                        left: BorderSide(color: Color(0xFF39D353), width: 3),
                      ),
                    ),
                    child: Text(
                      "// OpenSpark Blueprint Scope\nblueprint_metadata {\n  spark_id: 'SPK-${displayId.toUpperCase()}',\n  mode: 'pre_github_refinement',\n  vetted_by_community: true\n}",
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        color: Color(0xFF8B949E),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF8B949E)),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 11,
            color: Color(0xFF8B949E),
          ),
        ),
      ],
    );
  }
}