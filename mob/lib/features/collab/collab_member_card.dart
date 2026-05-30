import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'collab_chat_screen.dart';
import 'collab_operator_screen.dart'; // NEW: Import flat screen component
import 'collab_provider.dart';

class CollabMemberCard extends ConsumerWidget {
  final CollabProfileModel profile;

  const CollabMemberCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayId = profile.id.length > 6 ? profile.id.substring(0, 6) : profile.id;
    final connectedNodes = ref.watch(connectedNodesProvider);
    final isConnected = connectedNodes.contains(profile.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TerminalBlock(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTERACTIVE WRAPPER: Clicking on the core profile block opens the details screen
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CollabOperatorScreen(profile: profile),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(profile.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.displayName,
                                style: context.terminalText.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NODE_REF: $displayId • ${profile.sparkPoints} PTS',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: Color(0xFF8B949E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            border: Border.all(
                              color: profile.statusLabel == 'core'
                                  ? context.terminalColors.primary
                                  : const Color(0xFF30363D),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            profile.statusLabel.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 10,
                              color: profile.statusLabel == 'core'
                                  ? context.terminalColors.primary
                                  : const Color(0xFF8B949E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: profile.specializations.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1117),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF21262D)),
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
            ),
            
            const SizedBox(height: 10),
            const Divider(color: Color(0xFF21262D), height: 1),
            const SizedBox(height: 10),
            
            // Operations Footer remains independent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.link_rounded, 
                      size: 14, 
                      color: isConnected ? context.terminalColors.primary : const Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConnected ? 'handshake_established' : 'awaiting_handshake',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono', 
                        fontSize: 12, 
                        color: isConnected ? context.terminalColors.primary : const Color(0xFF8B949E),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CollabChatScreen(profile: profile)),
                      );
                    } else {
                      ref.read(connectedNodesProvider.notifier).update((state) => {...state, profile.id});
                    }
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isConnected ? const Color(0xFF161B22) : const Color(0xFF21262D),
                      border: Border.all(
                        color: isConnected ? context.terminalColors.primary : const Color(0xFF30363D),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isConnected ? 'MESSAGE' : 'CONNECT',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isConnected ? Colors.white : const Color(0xFF39D353),
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
  }
}