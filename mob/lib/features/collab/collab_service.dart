import 'package:supabase_flutter/supabase_flutter.dart';

class CollabService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchNetworkProfiles() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .order('spark_points', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertMessagePacket({
    required String senderId,
    required String recipientId,
    required String text,
  }) async {
    await _supabase.from('messages').insert({
      'sender_id': senderId,
      'recipient_id': recipientId,
      'text': text,
    });
  }
}
