import 'package:OpenSpark/features/dashboard/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'design_system/app_theme.dart';
import 'environment.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate environmental configurations
  Environment.validate();

  // Initialize the Supabase backend configuration globally
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'OpenSpark Mainframe',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: authStateAsync.when(
        data: (state) {
          // If a session exists securely, transition deep inside the application main dashboard
          if (state.session != null) {
            return const MainShell();
          }
          // Otherwise, direct the operator straight onto the gate login viewport
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF39D353)),
          ),
        ),
        error: (err, stack) => Scaffold(
          body: Center(
            child: Text(
              'CRITICAL_AUTH_ERROR: $err',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
