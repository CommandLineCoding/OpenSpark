import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';

class ProfileLogConsole extends ConsumerWidget {
  const ProfileLogConsole({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(profileLogProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF000B0E),
        border: Border.all(color: const Color(0xFF21262D)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF0D1117),
            child: const Row(
              children: [
                Icon(Icons.analytics_outlined, size: 14, color: Color(0xFF8B949E)),
                SizedBox(width: 6),
                Text(
                  'SYSTEM_RUNTIME_STREAM (LIVE)',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    color: Color(0xFF8B949E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, idx) {
                final log = logs[idx];
                Color tagColor = const Color(0xFF39D353);
                
                if (log.tag == 'WARN' || log.tag == 'ERR') {
                  tagColor = Colors.redAccent;
                } else if (log.tag == 'AUTH' || log.tag == 'DB_SYNC') {
                  tagColor = const Color(0xFFFFBD2E);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, height: 1.3),
                      children: [
                        TextSpan(text: '${log.time} ', style: const TextStyle(color: Color(0xFF8B949E))),
                        TextSpan(text: '[${log.tag}] ', style: TextStyle(color: tagColor, fontWeight: FontWeight.bold)),
                        TextSpan(text: log.message, style: const TextStyle(color: Color(0xFFC9D1D9))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}