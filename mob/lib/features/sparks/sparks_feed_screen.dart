import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'create_spark_screen.dart';
import 'spark_detail_screen.dart';
import 'sparks_provider.dart';

class SparksFeedScreen extends ConsumerWidget {
  const SparksFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sparksAsync = ref.watch(sparksFeedProvider);

    // --- DYNAMIC TELEMETRY CALCULATION ---
    // Extracts the real-time data from the provider to power the top dashboard
    final activeNodesCount = sparksAsync.valueOrNull?.length ?? 0;
    final totalNetworkVotes =
        sparksAsync.valueOrNull?.fold<int>(
          0,
          (sum, spark) => sum + spark.upvotes,
        ) ??
        0;

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'OpenSpark',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateSparkScreen(),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: RefreshIndicator(
        color: context.terminalColors.primary,
        backgroundColor: const Color(0xFF0D1117),
        onRefresh: () => ref.read(sparksFeedProvider.notifier).refreshFeed(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Top Telemetry Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Sparks',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39D353),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'SYS_ONLINE',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        color: Color(0xFF8B949E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- DYNAMIC TELEMETRY DASHBOARD ---
            Row(
              children: [
                Expanded(
                  child: TerminalBlock(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ACTIVE_NODES',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            color: Color(0xFF8B949E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$activeNodesCount',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.terminalColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TerminalBlock(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NETWORK_VOTES',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            color: Color(0xFF8B949E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$totalNetworkVotes',
                          // Changed from red to terminal yellow to represent engagement energy
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFBD2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- CORE FEED LIST ---
            sparksAsync.when(
              data: (sparks) {
                if (sparks.isEmpty)
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Text(
                        'NO_ACTIVE_IDEAS_FOUND',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: Color(0xFF8B949E),
                        ),
                      ),
                    ),
                  );

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sparks.length,
                  itemBuilder: (context, idx) {
                    final spark = sparks[idx];
                    final displayId = spark.id.length > 4
                        ? spark.id.substring(0, 4).toUpperCase()
                        : spark.id.toUpperCase();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TerminalBlock(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Tag Matrix
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.bolt,
                                  color: context.terminalColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    spark.title,
                                    style: const TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusTag(spark.status, context),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Clean ID Tracker under title
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                'ID: SPK-$displayId',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  color: Color(0xFF8B949E),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              spark.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFC9D1D9),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: spark.techStack
                                  .map(
                                    (tech) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF161B22),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: const Color(0xFF30363D),
                                        ),
                                      ),
                                      child: Text(
                                        tech,
                                        style: const TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 11,
                                          color: Color(0xFF8B949E),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),

                            // Brutalist Dotted Line
                            const Text(
                              '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .',
                              style: TextStyle(
                                color: Color(0xFF30363D),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(height: 16),

                            // Interaction Footer
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Color(0xFF8B949E),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  spark.timeAgo,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    color: Color(0xFF8B949E),
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),

                                InkWell(
                                  onTap: () => ref
                                      .read(sparksFeedProvider.notifier)
                                      .toggleVoteOptimistic(spark.id),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: spark.isUpvotedByMe
                                          ? context.terminalColors.primary
                                                .withAlpha(25)
                                          : const Color(0xFF161B22),
                                      border: Border.all(
                                        color: spark.isUpvotedByMe
                                            ? context.terminalColors.primary
                                            : const Color(0xFF30363D),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_up_rounded,
                                          size: 20,
                                          color: spark.isUpvotedByMe
                                              ? context.terminalColors.primary
                                              : const Color(0xFF8B949E),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${spark.upvotes}',
                                          style: TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: spark.isUpvotedByMe
                                                ? context.terminalColors.primary
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SparkDetailScreen(spark: spark),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF161B22),
                                      border: Border.all(
                                        color: const Color(0xFF30363D),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'INSPECT',
                                      style: TextStyle(
                                        fontFamily: 'JetBrains Mono',
                                        fontSize: 11,
                                        color: Color(0xFF39D353),
                                        fontWeight: FontWeight.bold,
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
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: CircularProgressIndicator(color: Color(0xFF39D353)),
                ),
              ),
              error: (err, _) => Center(
                child: Text(
                  'MATRIX_FETCH_FAULT: $err',
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status, BuildContext context) {
    Color tagColor;
    Color textColor;
    String text = status.toUpperCase();
    switch (status.toLowerCase()) {
      case 'sprout':
        tagColor = const Color(0xFFFFBD2E).withAlpha(35);
        textColor = const Color(0xFFFFBD2E);
        break;
      case 'ignited':
        tagColor = const Color(0xFF39D353).withAlpha(35);
        textColor = const Color(0xFF39D353);
        break;
      case 'seed':
      default:
        tagColor = const Color(0xFF21262D);
        textColor = const Color(0xFF8B949E);
        text = 'SEED';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor,
        border: Border.all(color: textColor.withAlpha(120)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
