import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkillsSelectionScreen extends ConsumerWidget {
  const SkillsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("GAME ATTRIBUTES",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                SkillGroup(
                  title: "PACE",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.paceRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setPaceRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Acceleration",
                      values: filters.accelerationRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setAccelerationRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Sprint Speed",
                      values: filters.sprintSpeedRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setSprintSpeedRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "SHOOTING",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.shootingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setShootingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Positioning",
                      values: filters.positioningRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setPositioningRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Finishing",
                      values: filters.finishingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setFinishingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Shot Power",
                      values: filters.shotPowerRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setShotPowerRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Long Shots",
                      values: filters.longShotsRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setLongShotsRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Volleys",
                      values: filters.volleysRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setVolleysRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Penalties",
                      values: filters.penaltiesRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setPenaltiesRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "PASSING",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.passingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setPassingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Vision",
                      values: filters.visionRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setVisionRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Crossing",
                      values: filters.crossingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setCrossingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "FK Accuracy",
                      values: filters.fkAccuracyRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setFkAccuracyRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Short Passing",
                      values: filters.shortPassingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setShortPassingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Long Passing",
                      values: filters.longPassingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setLongPassingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Curve",
                      values: filters.curveRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setCurveRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "DRIBBLING",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.dribblingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setDribblingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Agility",
                      values: filters.agilityRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setAgilityRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Balance",
                      values: filters.balanceRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setBalanceRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Reactions",
                      values: filters.reactionsRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setReactionsRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Ball Control",
                      values: filters.ballControlRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setBallControlRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Dribbling",
                      values: filters.dribblingSkillRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setDribblingSkillRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Composure",
                      values: filters.composureRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setComposureRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "DEFENDING",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.defendingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setDefendingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Interceptions",
                      values: filters.interceptionsRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setInterceptionsRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Heading Accuracy",
                      values: filters.headingAccuracyRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setHeadingAccuracyRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Marking",
                      values: filters.markingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setMarkingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Standing Tackle",
                      values: filters.standingTackleRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setStandingTackleRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Sliding Tackle",
                      values: filters.slidingTackleRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setSlidingTackleRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Jumping",
                      values: filters.jumpingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setJumpingRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "PHYSICAL",
                  children: [
                    RangeFilterSection(
                      title: "Summary",
                      values: filters.physicalRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setPhysicalRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Stamina",
                      values: filters.staminaRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setStaminaRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Strength",
                      values: filters.strengthRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setStrengthRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Aggression",
                      values: filters.aggressionRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setAggressionRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
                SkillGroup(
                  title: "GOALKEEPING",
                  children: [
                    RangeFilterSection(
                      title: "Diving",
                      values: filters.gkDivingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkDivingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Handling",
                      values: filters.gkHandlingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkHandlingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Kicking",
                      values: filters.gkKickingRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkKickingRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Reflexes",
                      values: filters.gkReflexesRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkReflexesRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Speed",
                      values: filters.gkSpeedRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkSpeedRange(v),
                      showBackground: false,
                    ),
                    RangeFilterSection(
                      title: "Positioning",
                      values: filters.gkPositioningRange,
                      min: 0,
                      max: 99,
                      onChanged: (v) => notifier.setGkPositioningRange(v),
                      showBackground: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scaffoldColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.posColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("DONE",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
