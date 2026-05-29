import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider exposing the core Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// StreamProvider listening to raw authorization transitions (logged in, out, or token refreshed)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Provider returning the current authenticated user instance profile if available
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? Supabase.instance.client.auth.currentUser;
});

/// State notifier managing processing states during continuous OAuth authentication round-trips
final authLoadingProvider = StateProvider<bool>((ref) => false);
