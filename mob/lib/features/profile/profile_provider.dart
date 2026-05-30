import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LogEntry {
  final String time;
  final String tag;
  final String message;

  LogEntry({
    required this.time,
    required this.tag,
    required this.message,
  });
}

class ProfileLogNotifier extends StateNotifier<List<LogEntry>> {
  ProfileLogNotifier() : super([]) {
    pushLog('SYS_BOOT', 'OpenSpark runtime matrix core bound to environment.');
  }

  void pushLog(String tag, String message) {
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    final newEntry = LogEntry(time: timestamp, tag: tag, message: message);
    
    // Cap log buffer sizes at 12 records to prevent layout drift
    state = [newEntry, ...state];
    if (state.length > 12) {
      state = state.sublist(0, 12);
    }
  }
}

final profileLogProvider = StateNotifierProvider<ProfileLogNotifier, List<LogEntry>>((ref) {
  return ProfileLogNotifier();
});