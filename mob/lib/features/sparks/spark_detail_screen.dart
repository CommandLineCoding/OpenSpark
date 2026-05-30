import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../auth/auth_provider.dart';
import 'sparks_provider.dart';

class SparkDetailScreen extends ConsumerStatefulWidget {
  final SparkModel spark;
  const SparkDetailScreen({super.key, required this.spark});

  @override
  ConsumerState<SparkDetailScreen> createState() => _SparkDetailScreenState();
}

class _SparkDetailScreenState extends ConsumerState<SparkDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRefinementMessage() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    try {
      await ref
          .read(sparksServiceProvider)
          .insertComment(
            sparkId: widget.spark.id,
            authorId: currentUser.id,
            content: text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('TRANSMISSION_DROP: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(
      sparkCommentsStreamProvider(widget.spark.id),
    );

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
        title: const Text(
          'OpenSpark',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: Color(0xFF39D353),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                widget.spark.title,
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
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
                                color: const Color(0xFF161B22),
                                border: Border.all(
                                  color: const Color(0xFF30363D),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.spark.status.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: Color(0xFFFFBD2E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v1.0.0-blueprint • Refined ${widget.spark.timeAgo} by @${widget.spark.authorName}',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            color: Color(0xFF8B949E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1117),
                            border: Border.all(color: const Color(0xFF21262D)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.gavel_rounded,
                                size: 14,
                                color: context.terminalColors.primary,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'LICENSE: OPEN_SOURCE_BY_DEFAULT (MIT/APACHE2)',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 10,
                                    color: Color(0xFF8B949E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TerminalBlock(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 16,
                              color: Color(0xFF8B949E),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'BLUEPRINT_SPECIFICATION.MD',
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                fontSize: 12,
                                color: Color(0xFF8B949E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Color(0xFF21262D)),
                        const SizedBox(height: 12),
                        Text(
                          widget.spark.description,
                          style: const TextStyle(
                            color: Color(0xFFC9D1D9),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '// refinement_thread (Idea PRs)',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: context.terminalColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  commentsAsync.when(
                    data: (comments) {
                      if (comments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              'Awaiting initial peer architectural patch...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: Color(0xFF8B949E),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TerminalBlock(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '@${comment.authorName}',
                                        style: const TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 11,
                                          color: Color(0xFFFFBD2E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'patch_submitted',
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 10,
                                          color: Color(0xFF8B949E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      color: Color(0xFFC9D1D9),
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF39D353),
                      ),
                    ),
                    error: (err, _) => Text(
                      'THREAD_SYNC_FAULT: $err',
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF001117),
              border: Border(top: BorderSide(color: Color(0xFF21262D))),
            ),
            child: Row(
              children: [
                Text(
                  '\$ ',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    color: context.terminalColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    cursorColor: context.terminalColors.primary,
                    decoration: const InputDecoration(
                      hintText: 'propose_architectural_patch...',
                      hintStyle: TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _submitRefinementMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.subdirectory_arrow_left_rounded,
                    color: context.terminalColors.primary,
                    size: 18,
                  ),
                  onPressed: _submitRefinementMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
