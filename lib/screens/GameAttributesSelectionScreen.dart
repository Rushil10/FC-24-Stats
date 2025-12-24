import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameAttributesSelectionScreen extends ConsumerWidget {
  const GameAttributesSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "PHYSICAL & SKILLS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                SkillGroup(
                  title: "PHYSICAL",
                  children: [
                    RangeFilterSection(
                      title: "Height (cm)",
                      values: filters.heightRange,
                      min: 120,
                      max: 220,
                      onChanged: (v) => notifier.setHeightRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Weight (kg)",
                      values: filters.weightRange,
                      min: 40,
                      max: 110,
                      onChanged: (v) => notifier.setWeightRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "TECHNICAL",
                  children: [
                    RangeFilterSection(
                      title: "Skill Moves",
                      values: filters.skillMovesRange,
                      min: 1,
                      max: 5,
                      onChanged: (v) => notifier.setSkillMovesRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Weak Foot",
                      values: filters.weakFootRange,
                      min: 1,
                      max: 5,
                      onChanged: (v) => notifier.setWeakFootRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Int'l Reputation",
                      values: filters.internationalReputationRange,
                      min: 1,
                      max: 5,
                      onChanged: (v) =>
                          notifier.setInternationalReputationRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0),
                  Colors.black,
                ],
              ),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.posColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 0),
                elevation: 8,
                shadowColor: appColors.posColor.withValues(alpha: 0.4),
              ),
              child: const Text(
                "DONE",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
