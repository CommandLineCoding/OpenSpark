import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'collab_service.dart';

class CollabProfileModel {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final int sparkPoints;
  final List<String> specializations;
  final String statusLabel;

  const CollabProfileModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.sparkPoints,
    required this.specializations,
    required this.statusLabel,
  });
}

class MessageModel {
  final String id;
  final String senderId;
  final String recipientId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.text,
    required this.timestamp,
  });
}

final collabServiceProvider = Provider((ref) => CollabService());
final connectedNodesProvider = StateProvider<Set<String>>((ref) => {});
final collabFilterProvider = StateProvider<String>((ref) => 'ALL');
final collabSearchProvider = StateProvider<String>((ref) => '');

final chatStreamProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  peerId,
) {
  final supabase = ref.watch(supabaseClientProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return Stream.value([]);

  return supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: true)
      .map((snapshot) {
        final messages = snapshot.map((data) {
          return MessageModel(
            id: data['id'].toString(),
            senderId: data['sender_id'].toString().toLowerCase(),
            recipientId: data['recipient_id'].toString().toLowerCase(),
            text: data['text'].toString(),
            timestamp: data['created_at'] != null
                ? DateTime.parse(data['created_at'].toString()).toLocal()
                : DateTime.now(),
          );
        }).toList();

        final myId = currentUser.id.toLowerCase();
        final otherId = peerId.toLowerCase();

        return messages
            .where(
              (msg) =>
                  (msg.senderId == myId && msg.recipientId == otherId) ||
                  (msg.senderId == otherId && msg.recipientId == myId),
            )
            .toList();
      });
});

final collabMatrixProvider =
    AsyncNotifierProvider<CollabMatrixNotifier, List<CollabProfileModel>>(() {
      return CollabMatrixNotifier();
    });

class CollabMatrixNotifier extends AsyncNotifier<List<CollabProfileModel>> {
  @override
  Future<List<CollabProfileModel>> build() async {
    final service = ref.watch(collabServiceProvider);
    final currentUser = ref.watch(currentUserProvider);
    final rawData = await service.fetchNetworkProfiles();

    final staticSpecs = [
      ['INFRA', 'Rust', 'Go'],
      ['SEC', 'C++', 'Wasm'],
      ['FRONTEND', 'Angular', 'TS'],
      ['AI', 'Python', 'Ollama'],
    ];

    int trackIdx = 0;
    final List<CollabProfileModel> profilesList = [];

    for (var data in rawData) {
      final String profileId = data['id']?.toString() ?? '';

      if (currentUser != null &&
          profileId.toLowerCase() == currentUser.id.toLowerCase()) {
        continue;
      }

      final currentSpecs = staticSpecs[trackIdx % staticSpecs.length];
      trackIdx++;

      final fallbackUsername = data['username']?.toString() ?? 'anonymous_node';

      profilesList.add(
        CollabProfileModel(
          id: profileId,
          username: fallbackUsername,
          displayName: data['display_name']?.toString() ?? fallbackUsername,
          avatarUrl:
              data['avatar_url']?.toString() ??
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
          sparkPoints: data['spark_points'] ?? 0,
          specializations: currentSpecs,
          statusLabel: data['spark_points'] != null && data['spark_points'] > 50
              ? 'core'
              : 'node',
        ),
      );
    }
    return profilesList;
  }

  Future<void> refreshMatrix() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
