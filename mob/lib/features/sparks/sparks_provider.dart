import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/auth_provider.dart';
import 'sparks_service.dart';

final sparksServiceProvider = Provider((ref) => SparksService());

class SparkModel {
  final String id,
      title,
      description,
      status,
      timeAgo,
      authorName,
      authorAvatar;
  final List<String> techStack;
  final int upvotes;
  final bool isUpvotedByMe;

  SparkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.status,
    required this.timeAgo,
    required this.upvotes,
    required this.isUpvotedByMe,
    required this.authorName,
    required this.authorAvatar,
  });

  SparkModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? techStack,
    String? status,
    String? timeAgo,
    int? upvotes,
    bool? isUpvotedByMe,
    String? authorName,
    String? authorAvatar,
  }) {
    return SparkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      techStack: techStack ?? this.techStack,
      status: status ?? this.status,
      timeAgo: timeAgo ?? this.timeAgo,
      upvotes: upvotes ?? this.upvotes,
      isUpvotedByMe: isUpvotedByMe ?? this.isUpvotedByMe,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }
}

class SparksFeedNotifier extends AsyncNotifier<List<SparkModel>> {
  @override
  Future<List<SparkModel>> build() async {
    final service = ref.watch(sparksServiceProvider);
    final currentUser = ref.watch(currentUserProvider);

    // 1. Fetch raw sparks from your RPC-backed schema
    final rawSparks = await service.fetchSparks();

    // 2. Fetch active user's vote set for mapping
    final myVotes = currentUser != null
        ? await service.fetchUserVotes(currentUser.id)
        : <String>{};

    return rawSparks.map((data) {
      final authorData = data['profiles'] as Map<String, dynamic>?;

      final createdAt = DateTime.parse(data['created_at'].toString());
      final diff = DateTime.now().difference(createdAt);
      String timeAgo = '${diff.inMinutes}m ago';
      if (diff.inHours > 0) timeAgo = '${diff.inHours}h ago';
      if (diff.inDays > 0) timeAgo = '${diff.inDays}d ago';

      return SparkModel(
        id: data['id'].toString(),
        title: data['title']?.toString() ?? 'Untitled Blueprint',
        // Maps to your specific description_markdown column
        description:
            data['description_markdown']?.toString() ??
            data['description']?.toString() ??
            '',
        techStack: List<String>.from(data['tech_stack'] ?? []),
        status: data['status']?.toString() ?? 'seed',
        timeAgo: timeAgo,
        upvotes: data['upvotes'] as int? ?? 0,
        isUpvotedByMe: myVotes.contains(data['id'].toString()),
        authorName: authorData?['username']?.toString() ?? 'anonymous',
        authorAvatar:
            authorData?['avatar_url']?.toString() ??
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      );
    }).toList();
  }

  Future<void> refreshFeed() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> toggleVoteOptimistic(String sparkId) async {
    final oldState = state.value;
    if (oldState == null) return;

    // Instant UI update
    state = AsyncValue.data(
      oldState.map((spark) {
        if (spark.id == sparkId) {
          final change = spark.isUpvotedByMe ? -1 : 1;
          return spark.copyWith(
            upvotes: spark.upvotes + change,
            isUpvotedByMe: !spark.isUpvotedByMe,
          );
        }
        return spark;
      }).toList(),
    );

    try {
      // Execute your specific RPC backend function
      await ref.read(sparksServiceProvider).toggleVoteRpc(sparkId);
    } catch (e) {
      state = AsyncValue.data(oldState); // Rollback on drop
    }
  }
}

final sparksFeedProvider =
    AsyncNotifierProvider<SparksFeedNotifier, List<SparkModel>>(
      () => SparksFeedNotifier(),
    );

// --- Comments Matrix ---
class SparkCommentModel {
  final String id, sparkId, authorName, content, timeAgo;
  SparkCommentModel({
    required this.id,
    required this.sparkId,
    required this.authorName,
    required this.content,
    required this.timeAgo,
  });
}

final sparkCommentsStreamProvider =
    StreamProvider.family<List<SparkCommentModel>, String>((ref, sparkId) {
      final supabase = ref.watch(supabaseClientProvider);
      return supabase
          .from('spark_comments')
          .stream(primaryKey: ['id'])
          .eq('spark_id', sparkId)
          .order('created_at', ascending: true)
          .map((snapshot) {
            return snapshot
                .map(
                  (data) => SparkCommentModel(
                    id: data['id'].toString(),
                    sparkId: data['spark_id'].toString(),
                    authorName: 'peer_node',
                    content: data['content'].toString(),
                    timeAgo: 'Just now',
                  ),
                )
                .toList();
          });
    });
