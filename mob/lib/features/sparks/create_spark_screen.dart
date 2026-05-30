import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../auth/auth_provider.dart';
import 'sparks_provider.dart';

class CreateSparkScreen extends ConsumerStatefulWidget {
  const CreateSparkScreen({super.key});

  @override
  ConsumerState<CreateSparkScreen> createState() => _CreateSparkScreenState();
}

class _CreateSparkScreenState extends ConsumerState<CreateSparkScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _techController = TextEditingController();
  bool _isPublishing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _techController.dispose();
    super.dispose();
  }

  Future<void> _publishSpark() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final tech = _techController.text.trim();

    if (title.isEmpty || desc.isEmpty) return;
    setState(() => _isPublishing = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('No active session token');

      final techList = tech.isEmpty
          ? <String>[]
          : tech
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
      await ref
          .read(sparksServiceProvider)
          .insertSpark(
            title: title,
            description: desc,
            techStack: techList,
            authorId: currentUser.id,
          );

      ref.read(sparksFeedProvider.notifier).refreshFeed();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('PUBLISH_ERR: ${e.toString()}'),
          ),
        );
        setState(() => _isPublishing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Initialize Spark',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BLUEPRINT_TITLE',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D1117),
                      hintText: 'e.g., Distributed Redis Cache Wrapper',
                      hintStyle: const TextStyle(color: Color(0xFF30363D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: context.terminalColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'TECH_STACK (comma separated)',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _techController,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D1117),
                      hintText: 'rust, webassembly, react',
                      hintStyle: const TextStyle(color: Color(0xFF30363D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: context.terminalColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'ARCHITECTURE_SPECIFICATION',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    maxLines: 8,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D1117),
                      hintText: 'Define core layout and data structures...',
                      hintStyle: const TextStyle(color: Color(0xFF30363D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF21262D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: context.terminalColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.terminalColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: _isPublishing ? null : _publishSpark,
                child: _isPublishing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'COMMIT_BLUEPRINT',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
