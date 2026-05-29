import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/terminal_block.dart';
import '../auth/auth_provider.dart';
import 'profile_provider.dart';

class ProfileAccountCard extends ConsumerStatefulWidget {
  final String initialUsername;
  const ProfileAccountCard({super.key, required this.initialUsername});

  @override
  ConsumerState<ProfileAccountCard> createState() => _ProfileAccountCardState();
}

class _ProfileAccountCardState extends ConsumerState<ProfileAccountCard> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.initialUsername;
    final user = ref.read(currentUserProvider);
    _emailController.text = user?.email ?? 'root@openspark.dev';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isSaving = true);
    ref.read(profileLogProvider.notifier).pushLog('DB_WRITE', 'Streaming fresh parameters to profiles table...');

    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.from('profiles').update({
        'username': _usernameController.text.trim(),
      }).eq('id', user.id);

      ref.read(profileLogProvider.notifier).pushLog('SUCCESS', 'Database records synchronized successfully.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: context.terminalColors.primary,
            content: const Text('TRANSMISSION_COMPLETE: Profile updated.', style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.black)),
          ),
        );
      }
    } catch (e) {
      ref.read(profileLogProvider.notifier).pushLog('ERR', 'PostgREST fault: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TerminalBlock(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT CONFIGURATION',
            style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, fontWeight: FontWeight.bold, color: context.terminalColors.primary, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          const Divider(color: Color(0xFF21262D), height: 1),
          const SizedBox(height: 16),
          _buildLabel('USERNAME'),
          _buildField(_usernameController, enabled: true),
          const SizedBox(height: 16),
          _buildLabel('EMAIL_ADDRESS'),
          _buildField(_emailController, enabled: false),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.terminalColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 0,
              ),
              onPressed: _isSaving ? null : _updateProfile,
              child: _isSaving
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Text('Update Account', style: TextStyle(fontFamily: 'JetBrains Mono', fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Text(text, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8B949E))),
      );

  Widget _buildField(TextEditingController controller, {required bool enabled}) => TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(fontFamily: 'JetBrains Mono', color: enabled ? Colors.black : Colors.white60, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFF21262D),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        ),
      );
}