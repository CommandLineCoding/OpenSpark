import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active navigation coordinator index: 0 = Feed, 1 = Create, 2 = Profile
final navigationIndexProvider = StateProvider<int>((ref) => 0);