import 'package:supabase_flutter/supabase_flutter.dart';

class SparksService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all sparks joined with author profile data via explicit relation constraint matching your schema graph
  Future<List<Map<String, dynamic>>> fetchSparks() async {
    final response = await _supabase
        .from('sparks')
        .select('*, profiles!sparks_author_id_fkey(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch explicit listing of matching keys inside the join table matrix
  Future<Set<String>> fetchUserVotes(String userId) async {
    final response = await _supabase
        .from('votes')
        .select('spark_id')
        .eq('user_id', userId);
    return (response as List).map((v) => v['spark_id'].toString()).toSet();
  }

  /// Invokes database-level state atomic counter transitions via RPC
  Future<void> toggleVoteRpc(String sparkId) async {
    await _supabase.rpc('toggle_vote', params: {'p_spark_id': sparkId});
  }

  /// Injects clean record blocks into your sparks table schema matrix
  Future<void> insertSpark({
    required String title,
    required String description,
    required List<String> techStack,
    required String authorId,
  }) async {
    await _supabase.from('sparks').insert({
      'author_id': authorId,
      'title': title,
      'description_markdown': description,
      'tech_stack': techStack,
      'status': 'seed', // Automatically conforms to spark_status Enum bounds
    });
  }
}
