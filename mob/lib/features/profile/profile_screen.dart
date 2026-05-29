import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../auth/auth_provider.dart';
import 'profile_account_card.dart';
import 'profile_flags_card.dart';
import 'profile_log_console.dart';
import 'profile_provider.dart';
import 'profile_tokens_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;
  String _username = 'anonymous_node';
  int _sparkPoints = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateProfile());
  }

  Future<void> _hydrateProfile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final supabase = ref.read(supabaseClientProvider);
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (mounted && data != null) {
        setState(() {
          _username = data['username'] ?? 'anonymous_node';
          _sparkPoints = data['spark_points'] ?? 0;
          _isLoading = false;
        });
        ref
            .read(profileLogProvider.notifier)
            .pushLog('DB_SYNC', 'Profile records loaded for workspace matrix.');
      }
    } catch (e) {
      ref
          .read(profileLogProvider.notifier)
          .pushLog('ERR', 'Profile transaction crash: ${e.toString()}');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.terminalColors.neutralBg,
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF39D353)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'OpenSpark',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: Color(0xFF39D353),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF161B22),
            child: Icon(
              Icons.tune_rounded,
              size: 14,
              color: context.terminalColors.primary,
            ),
          ),
          const SizedBox(width: 16),
        ],
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
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your account and environment configuration.',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                color: Color(0xFF8B949E),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            // Spark Points Telemetry card
            TerminalBlock(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: context.terminalColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SPARK_POINTS',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: Color(0xFF8B949E),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '$_sparkPoints PTS',
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ProfileAccountCard(initialUsername: _username),
            const SizedBox(height: 16),
            const ProfileTokensCard(),
            const SizedBox(height: 16),
            const ProfileFlagsCard(),
            const SizedBox(height: 16),
            const ProfileLogConsole(),
            const SizedBox(height: 16),

            // Danger Zone
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF85149)),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF0D1117),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DANGER ZONE',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF85149),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF85149)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () =>
                          ref.read(supabaseClientProvider).auth.signOut(),
                      child: const Text(
                        'Terminate Instance',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: Color(0xFFF85149),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
