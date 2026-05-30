import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../sparks/sparks_provider.dart';
import 'terminal_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitCommand(String? activeSparkContext) {
    final text = _inputController.text;
    if (text.isEmpty) return;

    ref
        .read(terminalProvider.notifier)
        .executeCommand(text, activeSparkContext: activeSparkContext);
    _inputController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final terminalHistory = ref.watch(terminalProvider);
    final isProcessing = ref.watch(terminalProcessingProvider);
    final sparksAsync = ref.watch(sparksFeedProvider);
    final activeSparkContext = ref.watch(terminalSparkContextProvider);

    // Auto-scroll watcher
    ref.listen(terminalProvider, (previous, next) {
      if (previous != null && next.length > previous.length) {
        _scrollToBottom();
      }
    });

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
          'Coprocessor',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CONTEXT DROP-DOWN ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TerminalBlock(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: sparksAsync.when(
                data: (sparks) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: activeSparkContext,
                      hint: const Text(
                        'BIND TARGET BLUEPRINT CONTEXT',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: Color(0xFF8B949E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dropdownColor: const Color(0xFF0D1117),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.settings_input_component_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      items: sparks.map((spark) {
                        return DropdownMenuItem<String>(
                          value: spark.title,
                          child: Text(
                            'SPK: ${spark.title.toUpperCase()}',
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        ref.read(terminalSparkContextProvider.notifier).state =
                            value;
                        if (value != null) {
                          ref
                              .read(terminalProvider.notifier)
                              .injectSystemMessage(
                                '[SYS] Context shifted to: "$value".',
                              );
                          _scrollToBottom();
                        }
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF39D353),
                  ),
                ),
                error: (err, _) => const Text(
                  'CONTEXT_HYDRATION_ERR',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),

          // --- TERMINAL OUTPUT WINDOW ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF000B0E),
                border: Border.all(color: const Color(0xFF21262D)),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: terminalHistory.length,
                itemBuilder: (context, index) {
                  final line = terminalHistory[index];

                  if (line.role == TerminalRole.user) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${line.timestamp} ',
                              style: const TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: Color(0xFF8B949E),
                                fontSize: 12,
                              ),
                            ),
                            const TextSpan(
                              text: 'operator@node:~\$ ',
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: Color(0xFF39D353),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: line.text,
                              style: const TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        line.text,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 13,
                          color: line.role == TerminalRole.coprocessor
                              ? const Color(0xFFFFBD2E)
                              : const Color(0xFFC9D1D9),
                          height: 1.4,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          if (isProcessing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                '● COPROCESSOR_COMPUTING_TOKENS...',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  color: Color(0xFFFFBD2E),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // --- INPUT LINE ---
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              border: Border.all(color: const Color(0xFF30363D)),
              borderRadius: BorderRadius.circular(6),
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
                    controller: _inputController,
                    onSubmitted: (_) => _submitCommand(activeSparkContext),
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    cursorColor: context.terminalColors.primary,
                    decoration: const InputDecoration(
                      hintText: 'Enter command string...',
                      hintStyle: TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_return_rounded,
                    color: context.terminalColors.primary,
                    size: 18,
                  ),
                  onPressed: () => _submitCommand(activeSparkContext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
