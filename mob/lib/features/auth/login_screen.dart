import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../design_system/theme_extensions.dart';
import '../../design_system/widgets/execute_button.dart';
import '../../design_system/widgets/social_auth_button.dart';
import '../../design_system/widgets/terminal_card.dart';
import '../../design_system/widgets/terminal_text_field.dart';
import 'auth_service.dart';
import 'session_tabs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _authKeyController = TextEditingController();
  final _authService = AuthService();

  int _selectedTabIndex = 0;
  bool _isExecuting = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _authKeyController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isExecuting = true);
    try {
      await _authService.signInWithEmail(
        email: _userIdController.text.trim(),
        password: _authKeyController.text,
      );
    } on AuthException catch (e) {
      _showTerminalError(e.message);
    } catch (e) {
      _showTerminalError('Fatal exception: Mainframe access denied.');
    } finally {
      if (mounted) setState(() => _isExecuting = false);
    }
  }

  Future<void> _handleOAuth(String provider) async {
    try {
      if (provider == 'github') {
        await _authService.signInWithGitHub();
      }
    } on AuthException catch (e) {
      _showTerminalError(e.message);
    } catch (e) {
      _showTerminalError('OAuth structural handshake failure.');
    }
  }

  void _showTerminalError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          'ERROR: $message',
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OpenSpark',
                    style: context.terminalText.headlineMedium?.copyWith(
                      color: context.terminalColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SessionTabs(
                    selectedIndex: _selectedTabIndex,
                    onTabChanged: (index) =>
                        setState(() => _selectedTabIndex = index),
                  ),
                  const SizedBox(height: 16),
                  TerminalCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login_',
                          style: context.terminalText.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter credentials to access mainframe.',
                          style: context.terminalText.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TerminalTextField(
                          label: 'user_id',
                          prefixIcon: Icons.account_box_outlined,
                          hintText: 'root_admin',
                          controller: _userIdController,
                          validator: (val) => val!.isEmpty
                              ? 'Field execution criteria unfulfilled'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TerminalTextField(
                          label: 'auth_key',
                          prefixIcon: Icons.vpn_key_outlined,
                          hintText: '********',
                          obscureText: true,
                          controller: _authKeyController,
                          validator: (val) => val!.length < 6
                              ? 'Bounds violation: Minimum length 6'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'recover_key?',
                              style: context.terminalText.labelLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ExecuteButton(
                          label: 'Execute',
                          isLoading: _isExecuting,
                          onPressed: _handleEmailLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: context.terminalColors.secondary),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR_CONTINUE_WITH',
                          style: context.terminalText.labelLarge?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: context.terminalColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SocialAuthButton(
                          label: 'GitHub',
                          icon: Icons.terminal_outlined,
                          onPressed: () => _handleOAuth('github'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SocialAuthButton(
                          label: 'Google',
                          icon: Icons.stream,
                          onPressed: () => _handleOAuth('google'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
