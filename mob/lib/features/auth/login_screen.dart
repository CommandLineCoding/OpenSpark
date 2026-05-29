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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  int _selectedTabIndex = 0; // 0 = INITIATE_SESSION, 1 = CREATE_NODE
  bool _isExecuting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleTerminalExecution() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isExecuting = true);
    try {
      if (_selectedTabIndex == 0) {
        // Run standard authentication sequence
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Run remote node creation sequence
        await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          _showTerminalSuccess(
            'Node created successfully. Check email for confirmation handshake.',
          );
          setState(() => _selectedTabIndex = 0); // Toggle back to login tab
        }
      }
    } on AuthException catch (e) {
      _showTerminalError(e.message);
    } catch (e) {
      _showTerminalError('Fatal operational exception: Execution failed.');
    } finally {
      if (mounted) setState(() => _isExecuting = false);
    }
  }

  Future<void> _handleOAuth() async {
    try {
      await _authService.signInWithGitHub();
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

  void _showTerminalSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.terminalColors.primary,
        content: Text(
          'SUCCESS: $message',
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            color: Colors.black,
            fontWeight: FontWeight.bold,
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

                  // Section Tabs Selector
                  SessionTabs(
                    selectedIndex: _selectedTabIndex,
                    onTabChanged: (index) {
                      _formKey.currentState?.reset();
                      setState(() => _selectedTabIndex = index);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Interactive Terminal Frame Block
                  TerminalCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedTabIndex == 0 ? 'Login_' : 'Register_',
                          style: context.terminalText.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedTabIndex == 0
                              ? 'Enter credentials to access mainframe.'
                              : 'Provision a new identity node onto the matrix.',
                          style: context.terminalText.bodyMedium,
                        ),
                        const SizedBox(height: 24),

                        TerminalTextField(
                          label: 'user_email',
                          prefixIcon: Icons.alternate_email_rounded,
                          hintText: 'root@openspark.dev',
                          controller: _emailController,
                          validator: (val) {
                            if (val == null ||
                                val.isEmpty ||
                                !val.contains('@')) {
                              return 'Criteria missing: Invalid core email sequence';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        TerminalTextField(
                          label: 'auth_key',
                          prefixIcon: Icons.vpn_key_outlined,
                          hintText: '********',
                          obscureText: true,
                          controller: _passwordController,
                          validator: (val) {
                            if (val == null || val.length < 6) {
                              return 'Bounds violation: Minimum key length 6';
                            }
                            return null;
                          },
                        ),

                        if (_selectedTabIndex == 0) ...[
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
                          const SizedBox(height: 8),
                        ] else ...[
                          const SizedBox(height: 32),
                        ],

                        ExecuteButton(
                          label: 'Execute',
                          isLoading: _isExecuting,
                          onPressed: _handleTerminalExecution,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Structural Delineator Row
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

                  // Unified single-action GitHub button container
                  Row(
                    children: [
                      Expanded(
                        child: SocialAuthButton(
                          label: 'GitHub Mainframe',
                          icon: Icons.terminal_outlined,
                          onPressed: _handleOAuth,
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
