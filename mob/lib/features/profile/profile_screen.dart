import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;
  String _username = 'operator_node';
  String _avatarUrl =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200';
  int _sparkPoints = 0;

  // Local settings state
  bool _isPublicProfile = true;
  String _activeTheme = 'OpenSpark Dark';

  @override
  void initState() {
    super.initState();
    _fetchProfileTelemetry();
  }

  Future<void> _fetchProfileTelemetry() async {
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

      if (mounted) {
        setState(() {
          if (data != null) {
            _username = data['username']?.toString() ?? 'operator_node';
            _avatarUrl = data['avatar_url']?.toString() ?? _avatarUrl;
            _sparkPoints = data['spark_points'] as int? ?? 0;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- SETTINGS MODULE INTERFACES ---

  void _openThemeInjector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1117),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: Color(0xFF30363D)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '// THEME_INJECTOR',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  color: context.terminalColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption('OpenSpark Dark', true),
              const SizedBox(height: 8),
              _buildThemeOption('High Contrast Light (Beta)', false),
              const SizedBox(height: 8),
              _buildThemeOption('Matrix Green (Legacy)', false),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String name, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() => _activeTheme = name);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF161B22) : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF39D353)
                : const Color(0xFF30363D),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              Icons.terminal,
              size: 16,
              color: isSelected
                  ? const Color(0xFF39D353)
                  : const Color(0xFF8B949E),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                color: isSelected ? Colors.white : const Color(0xFF8B949E),
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Color(0xFF39D353),
              ),
          ],
        ),
      ),
    );
  }

  void _openExternalNodesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF30363D)),
        ),
        title: Text(
          'LINK_EXTERNAL_NODES',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTerminalTextField('GitHub URL...'),
            const SizedBox(height: 12),
            _buildTerminalTextField('Portfolio/Domain URL...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                color: Color(0xFF8B949E),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.terminalColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'SAVE_LINKS',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalTextField(String hint) {
    return TextField(
      style: const TextStyle(
        fontFamily: 'JetBrains Mono',
        color: Colors.white,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF161B22),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF30363D)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF21262D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF39D353)),
        ),
      ),
    );
  }

  // --- UI RENDER ---

  @override
  Widget build(BuildContext context) {
    final String nodeClass = _sparkPoints > 50 ? 'CORE_NODE' : 'STANDARD_NODE';
    final Color nodeColor = _sparkPoints > 50
        ? context.terminalColors.primary
        : const Color(0xFF8B949E);

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'System Profile',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            color: context.terminalColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () async =>
                await ref.read(supabaseClientProvider).auth.signOut(),
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF21262D), height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF39D353)),
            )
          : RefreshIndicator(
              color: context.terminalColors.primary,
              backgroundColor: const Color(0xFF0D1117),
              onRefresh: _fetchProfileTelemetry,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Identity Block
                  TerminalBlock(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_avatarUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@$_username',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161B22),
                                  border: Border.all(
                                    color: nodeColor.withAlpha(120),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'CLASS: $nodeClass',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: nodeColor,
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

                  // Gamification Telemetry Block
                  Row(
                    children: [
                      Expanded(
                        child: TerminalBlock(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'VIRTUAL_POINTS',
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: Color(0xFF8B949E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.stars_rounded,
                                    color: Color(0xFFFFBD2E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_sparkPoints',
                                    style: const TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFBD2E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Settings Module
                  const Text(
                    '// system_configurations',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Color(0xFF8B949E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TerminalBlock(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.palette_outlined,
                            color: Color(0xFF8B949E),
                            size: 20,
                          ),
                          title: const Text(
                            'THEME_INJECTOR',
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Active: $_activeTheme',
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 11,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF30363D),
                          ),
                          onTap: _openThemeInjector,
                        ),
                        const Divider(color: Color(0xFF21262D), height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.link_rounded,
                            color: Color(0xFF8B949E),
                            size: 20,
                          ),
                          title: const Text(
                            'EXTERNAL_NODES',
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'GitHub, Portfolio Links',
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 11,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF30363D),
                          ),
                          onTap: _openExternalNodesDialog,
                        ),
                        const Divider(color: Color(0xFF21262D), height: 1),
                        SwitchListTile(
                          activeThumbColor: Colors.black,
                          activeTrackColor: context.terminalColors.primary,
                          inactiveThumbColor: const Color(0xFF8B949E),
                          inactiveTrackColor: const Color(0xFF161B22),
                          secondary: const Icon(
                            Icons.security_rounded,
                            color: Color(0xFF8B949E),
                            size: 20,
                          ),
                          title: const Text(
                            'PRIVACY_MATRIX',
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Public Profile: ${_isPublicProfile ? "TRUE" : "FALSE"}',
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 11,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                          value: _isPublicProfile,
                          onChanged: (val) =>
                              setState(() => _isPublicProfile = val),
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
