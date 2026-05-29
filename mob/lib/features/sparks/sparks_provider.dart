import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'sparks_service.dart';

class SparkModel {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String status;
  final int upvotes;
  final String timeAgo;
  final String authorName;
  final String authorAvatar;
  final bool isUpvotedByMe;

  const SparkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.status,
    required this.upvotes,
    required this.timeAgo,
    required this.authorName,
    required this.authorAvatar,
    required this.isUpvotedByMe,
  });

  SparkModel copyWith({int? upvotes, bool? isUpvotedByMe}) {
    return SparkModel(
      id: id,
      title: title,
      description: description,
      techStack: techStack,
      status: status,
      upvotes: upvotes ?? this.upvotes,
      timeAgo: timeAgo,
      authorName: authorName,
      authorAvatar: authorAvatar,
      isUpvotedByMe: isUpvotedByMe ?? this.isUpvotedByMe,
    );
  }
}

final sparksServiceProvider = Provider((ref) => SparksService());

final sparksFeedProvider = AsyncNotifierProvider<SparksFeedNotifier, List<SparkModel>>(() {
  return SparksFeedNotifier();
});

class SparksFeedNotifier extends AsyncNotifier<List<SparkModel>> {
  late final SparksService _service;

  @override
  Future<List<SparkModel>> build() async {
    _service = ref.watch(sparksServiceProvider);
    return _fetchAllData();
  }

  Future<List<SparkModel>> _fetchAllData() async {
    final user = ref.read(currentUserProvider);
    final rawSparks = await _service.fetchSparks();
    
    Set<String> userVotes = {};
    if (user != null) {
      userVotes = await _service.fetchUserVotes(user.id);
    }

    return rawSparks.map((data) {
      final profile = data['profiles'] as Map<String, dynamic>?;
      final createdAt = DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
      final difference = DateTime.now().difference(createdAt);
      
      String timeAgo = '${difference.inMinutes}m ago';
      if (difference.inHours > 0) timeAgo = '${difference.inHours}h ago';
      if (difference.inDays > 0) timeAgo = '${difference.inDays}d ago';

      return SparkModel(
        id: data['id'].toString(),
        title: data['title'] ?? 'Untitled Spark',
        description: data['description_markdown'] ?? '',
        // Securely handle both direct array types or comma fallback streams from postgres selection
        techStack: data['tech_stack'] is List 
            ? List<String>.from(data['tech_stack'])
            : (data['tech_stack']?.toString().split(',') ?? []),
        status: data['status'] ?? 'seed',
        upvotes: data['upvotes'] ?? 0,
        timeAgo: timeAgo,
        authorName: profile?['username'] ?? 'anonymous_node',
        authorAvatar: profile?['avatar_url'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
        isUpvotedByMe: userVotes.contains(data['id'].toString()),
      );
    }).toList();
  }

  Future<void> refreshFeed() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAllData());
  }

  Future<String?> toggleVoteOptimistic(String sparkId) async {
    final previousState = state.value;
    if (previousState == null) return null;

    state = AsyncValue.data(
      previousState.map((spark) {
        if (spark.id == sparkId) {
          final isUpvoted = !spark.isUpvotedByMe;
          return spark.copyWith(
            isUpvotedByMe: isUpvoted,
            upvotes: isUpvoted ? spark.upvotes + 1 : spark.upvotes - 1,
          );
        }
        return spark;
      }).toList(),
    );

    try {
      await _service.toggleVoteRpc(sparkId);
      return null;
    } catch (e) {
      state = AsyncValue.data(previousState);
      return e.toString();
    }
  }
}