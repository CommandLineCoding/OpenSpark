import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum TerminalRole { system, user, coprocessor }

class TerminalLine {
  final String text;
  final TerminalRole role;
  final String timestamp;

  TerminalLine({
    required this.text,
    required this.role,
    required this.timestamp,
  });
}

// Tracks if the LLM is currently "thinking"
final terminalProcessingProvider = StateProvider<bool>((ref) => false);

// Tracks which Spark Blueprint the LLM is analyzing
final terminalSparkContextProvider = StateProvider<String?>((ref) => null);

class TerminalNotifier extends Notifier<List<TerminalLine>> {
  @override
  List<TerminalLine> build() {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());
    return [
      TerminalLine(
        text: 'OpenSpark LLM Coprocessor [Version 0.1.0-beta]',
        role: TerminalRole.system,
        timestamp: time,
      ),
      TerminalLine(
        text: 'Core threads spawned. Awaiting contextual commands.',
        role: TerminalRole.system,
        timestamp: time,
      ),
      TerminalLine(
        text: 'Type /help to view the available command matrix.',
        role: TerminalRole.system,
        timestamp: time,
      ),
    ];
  }

  Future<void> executeCommand(
    String input, {
    String? activeSparkContext,
  }) async {
    if (input.trim().isEmpty) return;
    if (ref.read(terminalProcessingProvider))
      return; // Prevent spamming while thinking

    final time = DateFormat('HH:mm:ss').format(DateTime.now());

    // 1. Instantly append the user's command to the terminal
    state = [
      ...state,
      TerminalLine(text: input, role: TerminalRole.user, timestamp: time),
    ];

    // 2. Clear Screen Command Logic
    if (input.trim() == '/clear') {
      ref.invalidateSelf(); // Resets the provider back to the initial boot screen
      return;
    }

    // 3. Lock the input and simulate network latency
    ref.read(terminalProcessingProvider.notifier).state = true;
    await Future.delayed(const Duration(milliseconds: 1500));

    final replyTime = DateFormat('HH:mm:ss').format(DateTime.now());
    String response = '';

    // 4. Simulated LLM Routing Logic (To be replaced with real OpenAI/Ollama API calls later)
    if (input.trim() == '/help') {
      response =
          'AVAILABLE_COMMAND_MATRIX:\n'
          '  /brainstorm  - Run core architectural ideation loops\n'
          '  /schema      - Scaffold relational database DDL matrices\n'
          '  /clear       - Flush terminal window history buffers';
    } else if (activeSparkContext == null &&
        (input.startsWith('/brainstorm') || input.startsWith('/schema'))) {
      response =
          '[WARN] No pipeline focus established. Select a blueprint node from the dropdown first.';
    } else if (input.startsWith('/brainstorm')) {
      response =
          '[LLM_OUTPUT] Feature Scope Expansion Matrix for "$activeSparkContext":\n'
          '1. Implement a stateless caching wrapper (e.g., Redis) to reduce DB loads.\n'
          '2. Isolate internal message workers to independent background daemons.\n'
          '3. Expose telemetry variables cleanly through Prometheus metrics blocks.';
    } else if (input.startsWith('/schema')) {
      response =
          '[LLM_OUTPUT] Generated Database Blueprint for "$activeSparkContext":\n'
          'CREATE TABLE node_metrics (\n'
          '  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n'
          '  payload_hash VARCHAR(64) NOT NULL,\n'
          '  tracked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n'
          ');';
    } else {
      response =
          '[LLM_OUTPUT] Acknowledged token payload. Vectorizing input context...\n'
          'To run deep architectural analysis, bind a project blueprint and use /brainstorm.';
    }

    // 5. Inject Coprocessor Response and unlock input
    state = [
      ...state,
      TerminalLine(
        text: response,
        role: TerminalRole.coprocessor,
        timestamp: replyTime,
      ),
    ];
    ref.read(terminalProcessingProvider.notifier).state = false;
  }

  void injectSystemMessage(String msg) {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());
    state = [
      ...state,
      TerminalLine(text: msg, role: TerminalRole.system, timestamp: time),
    ];
  }
}

final terminalProvider = NotifierProvider<TerminalNotifier, List<TerminalLine>>(
  () => TerminalNotifier(),
);
