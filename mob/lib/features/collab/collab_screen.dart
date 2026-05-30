import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/theme_extensions.dart';
import 'collab_member_card.dart';
import 'collab_provider.dart';

class CollabScreen extends ConsumerWidget {
  const CollabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(collabFilterProvider);
    final searchQuery = ref.watch(collabSearchProvider);
    final matrixAsync = ref.watch(collabMatrixProvider);

    final filterOptions = ['ALL', 'INFRA', 'SEC', 'FRONTEND', 'AI'];

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'OpenSpark',
          style: TextStyle(fontFamily: 'JetBrains Mono', color: context.terminalColors.primary, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(color: Color(0xFF21262D), height: 1)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '// collaborators_matrix',
              style: TextStyle(fontFamily: 'JetBrains Mono', color: context.terminalColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(collabSearchProvider.notifier).state = val.toLowerCase(),
              style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white, fontSize: 14),
              cursorColor: context.terminalColors.primary,
              decoration: InputDecoration(
                hintText: 'Search operators index...',
                hintStyle: const TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8B949E), size: 18),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF30363D)), borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.terminalColors.primary), borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: filterOptions.length,
              itemBuilder: (context, idx) {
                final option = filterOptions[idx];
                final isSelected = activeFilter == option;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => ref.read(collabFilterProvider.notifier).state = option,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? context.terminalColors.primary : const Color(0xFF161B22),
                        border: Border.all(color: isSelected ? context.terminalColors.primary : const Color(0xFF30363D)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : const Color(0xFF8B949E)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: matrixAsync.when(
              data: (profiles) {
                final filtered = profiles.where((profile) {
                  final matchesSearch = profile.username.toLowerCase().contains(searchQuery);
                  final matchesFilter = activeFilter == 'ALL' || profile.specializations.contains(activeFilter);
                  return matchesSearch && matchesFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'NO_OPERATOR_NODES_MATCH_CRITERIA',
                      style: TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFF8B949E), fontSize: 13),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: context.terminalColors.primary,
                  backgroundColor: const Color(0xFF0D1117),
                  onRefresh: () => ref.read(collabMatrixProvider.notifier).refreshMatrix(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) => CollabMemberCard(profile: filtered[idx]),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF39D353))),
              error: (err, stack) => Center(
                child: Text('MATRIX_COMPILATION_EXCEPTION: $err', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.redAccent)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}