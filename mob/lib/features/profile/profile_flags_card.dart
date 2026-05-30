import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import 'profile_provider.dart';

class ProfileFlagsCard extends ConsumerStatefulWidget {
  const ProfileFlagsCard({super.key});

  @override
  ConsumerState<ProfileFlagsCard> createState() => _ProfileFlagsCardState();
}

class _ProfileFlagsCardState extends ConsumerState<ProfileFlagsCard> {
  bool _autoDeploy = true;
  bool _verboseLogging = true;
  bool _telemetry = false;

  @override
  Widget build(BuildContext context) {
    return TerminalBlock(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ENVIRONMENT FLAGS',
            style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, fontWeight: FontWeight.bold, color: context.terminalColors.primary, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          const Divider(color: Color(0xFF21262D), height: 1),
          const SizedBox(height: 12),
          _buildSwitch('Auto-Deploy', 'Push directly to staging pools', _autoDeploy, (val) {
            setState(() => _autoDeploy = val);
            ref.read(profileLogProvider.notifier).pushLog('CONFIG', 'Auto-Deploy updated to [$val]');
          }),
          const Divider(color: Color(0xFF21262D), height: 24),
          _buildSwitch('Verbose Logging', 'Enable dense tracing loops', _verboseLogging, (val) {
            setState(() => _verboseLogging = val);
            ref.read(profileLogProvider.notifier).pushLog('CONFIG', 'Verbose engine printing set to [$val]');
          }),
          const Divider(color: Color(0xFF21262D), height: 24),
          _buildSwitch('Telemetry Stream', 'Send anonymous analytics tags', _telemetry, (val) {
            setState(() => _telemetry = val);
            ref.read(profileLogProvider.notifier).pushLog('CONFIG', 'Ecosystem telemetry tracking set to [$val]');
          }),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, String sub, bool value, ValueChanged<bool> target) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFF8B949E))),
            ]),
          ),
          Switch(
            value: value,
            onChanged: target,
            activeThumbColor: context.terminalColors.primary, // Deprecation issue completely fixed
            activeTrackColor: context.terminalColors.primary.withValues(alpha: 0.15),
            inactiveThumbColor: const Color(0xFF8B949E),
            inactiveTrackColor: const Color(0xFF161B22),
          ),
        ],
      );
}