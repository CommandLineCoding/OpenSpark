import 'package:flutter/material.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'collab_chat_screen.dart';
import 'collab_provider.dart';

class CollabOperatorScreen extends StatelessWidget {
  final CollabProfileModel profile;

  const CollabOperatorScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final displayId = profile.id.length > 8 ? profile.id.substring(0, 8) : profile.id;

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
        title: Text(
          '// operator_profile',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
            // Module 1: Bento Header Dossier Block
            TerminalBlock(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(profile.avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${profile.username}',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 14,
                            color: context.terminalColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                            'CLASS: ${profile.statusLabel.toUpperCase()}',
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Module 2: Grid Performance Telemetry Space
            Row(
              children: [
                Expanded(
                  child: TerminalBlock(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SPARK_SCORE',
                          style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: Color(0xFF8B949E)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.sparkPoints} PTS',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TerminalBlock(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NODE_INDEX',
                          style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: Color(0xFF8B949E)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${displayId.toUpperCase()}',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 18,
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
            const SizedBox(height: 16),

            // Module 3: Core Competencies Tag array
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CORE SPECIALIZATIONS',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.specializations.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1117),
                          border: Border.all(color: const Color(0xFF21262D)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tech,
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Module 4: Manifest Activity Log Console
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                border: Border.all(color: const Color(0xFF21262D)),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF8B949E)),
                      SizedBox(width: 8),
                      Text(
                        'MANIFEST_LOGS.TXT',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B949E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0xFF21262D)),
                  const SizedBox(height: 8),
                  _buildConsoleLine('Initializing secure peer link to matrix...'),
                  _buildConsoleLine('Status tracking set to ACTIVE_NODE.'),
                  _buildConsoleLine('Ready for joint pre-GitHub structural planning.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Execution Layer
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.terminalColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollabChatScreen(profile: profile)),
                  );
                },
                icon: const Icon(Icons.message_outlined, size: 16),
                label: const Text(
                  'OPEN CHAT SESSION',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '> $text',
        style: const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 12,
          color: Color(0xFF39D353),
        ),
      ),
    );
  }
}