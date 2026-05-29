import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/execute_button.dart';
import '../../design_system/widgets/terminal_card.dart';
import '../../design_system/widgets/terminal_text_field.dart';
import '../auth/auth_provider.dart';

import 'sparks_provider.dart';

class CreateSparkScreen extends ConsumerStatefulWidget {
  const CreateSparkScreen({super.key});

  @override
  ConsumerState<CreateSparkScreen> createState() => _CreateSparkScreenState();
}

class _CreateSparkScreenState extends ConsumerState<CreateSparkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitNode() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      _showTerminalMessage(
        'AUTH_FAILURE: Session operator not resolved.',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Parse comma-delimited strings into individual trimmed text tokens
    final techList = _techController.text
        .split(',')
        .map((tech) => tech.trim())
        .where((tech) => tech.isNotEmpty)
        .toList();

    try {
      await ref
          .read(sparksServiceProvider)
          .insertSpark(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            techStack: techList,
            authorId: user.id,
          );

      _showTerminalMessage(
        'TRANSMISSION_COMPLETE: Blueprint deployed to grid.',
      );

      // Force reload the feed provider state data
      await ref.read(sparksFeedProvider.notifier).refreshFeed();

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showTerminalMessage(
        'DATABASE_REJECTION: ${e.toString()}',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showTerminalMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? Colors.redAccent
            : context.terminalColors.primary,
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: isError ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '// deploy_blueprint',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: TerminalCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compile Node_',
                    style: context.terminalText.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fill code specs to provision an open spark entry.',
                    style: context.terminalText.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  TerminalTextField(
                    label: 'spark_title',
                    prefixIcon: Icons.title_rounded,
                    hintText: 'e.g., Hyper_UI_Engine',
                    controller: _titleController,
                    validator: (val) {
                      if (val == null ||
                          val.trim().length < 5 ||
                          val.trim().length > 200) {
                        return 'Bounds error: Title bounds must span [5, 200] items.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Customized multi-line block directly utilizing system input tokens
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: context.terminalColors.primary.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'description_markdown',
                        style: context.terminalText.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    cursorColor: context.terminalColors.primary,
                    style: context.terminalText.bodyMedium?.copyWith(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Null matrix data disallowed.'
                        : null,
                    decoration: InputDecoration(
                      hintText:
                          '# Project Overview\nWrite markdown schema parameters here...',
                      hintStyle: TextStyle(
                        color: context.terminalColors.secondary.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0D1117),
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.terminalColors.secondary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.terminalColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TerminalTextField(
                    label: 'target_tech_stack',
                    prefixIcon: Icons.layers_outlined,
                    hintText: 'Flutter, Supabase, Go, Rust',
                    controller: _techController,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Requires terminal stack parameter tags.'
                        : null,
                  ),
                  const SizedBox(height: 32),

                  ExecuteButton(
                    label: 'Deploy Spark',
                    isLoading: _isSubmitting,
                    onPressed: _handleSubmitNode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
