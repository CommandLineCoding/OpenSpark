import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'create_spark_screen.dart';
import 'spark_detail_screen.dart';
import 'sparks_provider.dart';

class SparksFeedScreen extends ConsumerWidget {
  const SparksFeedScreen({super.key});

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
    final sparksAsync = ref.watch(sparksFeedProvider);

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
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateSparkScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: sparksAsync.when(
        data: (sparks) {
          return RefreshIndicator(
            color: context.terminalColors.primary,
            backgroundColor: const Color(0xFF0D1117),
            onRefresh: () =>
                ref.read(sparksFeedProvider.notifier).refreshFeed(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sparks.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TerminalBlock(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Latest Sparks',
                                style: context.terminalText.headlineMedium
                                    ?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                      fontSize: 12,
                                      color: Color(0xFF8B949E),
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
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D1117),
                                    border: Border.all(
                                      color: const Color(0xFF30363D),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ACTIVE_NODES',
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 11,
                                          color: Color(0xFF8B949E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${sparks.length}',
                                        style: const TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF39D353),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D1117),
                                    border: Border.all(
                                      color: const Color(0xFF30363D),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ERRORS',
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 11,
                                          color: Color(0xFF8B949E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '0',
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
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

                final spark = sparks[index - 1];
                final displayId = spark.id.length > 4
                    ? spark.id.substring(0, 4)
                    : spark.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: TerminalBlock(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.flash_on_rounded,
                              color: context.terminalColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spark.title,
                                    style: context.terminalText.bodyMedium
                                        ?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ID: SPK-${displayId.toUpperCase()}',
                                    style: const TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      fontSize: 12,
                                      color: Color(0xFF8B949E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161B22),
                                border: Border.all(
                                  color: _getStatusColor(spark.status),
                                ),
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
                        const SizedBox(height: 12),

                        if (spark.description.isNotEmpty) ...[
                          Text(
                            spark.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFC9D1D9),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        if (spark.techStack.isNotEmpty) ...[
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: spark.techStack.map((tech) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
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
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],

                        const Text(
                          '. . . . . . . . . . . . . . . . . . . . . . . .',
                          style: TextStyle(
                            color: Color(0xFF30363D),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Color(0xFF8B949E),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  spark.timeAgo,
                                  style: context.terminalText.labelLarge
                                      ?.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final error = await ref
                                        .read(sparksFeedProvider.notifier)
                                        .toggleVoteOptimistic(spark.id);

                                    if (error != null && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                            'VOTE_TRANSMISSION_FAILED: $error',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: spark.isUpvotedByMe
                                          ? context.terminalColors.primary
                                                .withValues(alpha: 0.15)
                                          : const Color(0xFF0D1117),
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
                                          color: spark.isUpvotedByMe
                                              ? context.terminalColors.primary
                                              : const Color(0xFF8B949E),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 2),
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
                                const SizedBox(width: 8),

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SparkDetailScreen(spark: spark),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF21262D),
                                      border: Border.all(
                                        color: const Color(0xFF30363D),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'INSPECT',
                                      style: TextStyle(
                                        fontFamily: 'JetBrains Mono',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF39D353),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF39D353)),
        ),
        error: (err, stack) => Center(
          child: Text(
            'LOG_FETCH_EXCEPTION: $err',
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}
