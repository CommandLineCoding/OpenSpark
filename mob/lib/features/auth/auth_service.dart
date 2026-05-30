import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// GitHub OAuth strategy configuration
  Future<bool> signInWithGitHub() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.github,
      redirectTo: 'openspark://auth/callback',
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}