import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'profile_provider.dart';

class ProfileTokensCard extends ConsumerStatefulWidget {
  const ProfileTokensCard({super.key});

  @override
  ConsumerState<ProfileTokensCard> createState() => _ProfileTokensCardState();
}

class _ProfileTokensCardState extends ConsumerState<ProfileTokensCard> {
  String _deployToken = 'osp_live_7x9p...2a8b';
  int _generationIndex = 1;

  void _rotateToken() {
    setState(() {
      _generationIndex++;
      _deployToken = 'osp_live_${_generationIndex}k8w_${DateTime.now().millisecond}';
    });
    ref.read(profileLogProvider.notifier).pushLog('AUTH', 'Rotated personal access key token cluster: SHA-256 updated.');
  }

  @override
  Widget build(BuildContext context) {
    return TerminalBlock(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERSONAL ACCESS TOKENS',
            style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, fontWeight: FontWeight.bold, color: context.terminalColors.primary, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          const Divider(color: Color(0xFF21262D), height: 1),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              border: Border.all(color: const Color(0xFF30363D)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROD_DEPLOY_KEY', style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(_deployToken, style: const TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFF8B949E), fontSize: 12)),
                  ],
                ),
                const Text('Active', style: TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFF39D353), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.terminalColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: _rotateToken,
              icon: Icon(Icons.refresh_rounded, size: 16, color: context.terminalColors.primary),
              label: Text('Generate Token', style: TextStyle(fontFamily: 'JetBrains Mono', color: context.terminalColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}