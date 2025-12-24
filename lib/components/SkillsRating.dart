import 'package:fc_stats_24/components/SkillCard.dart';
import 'package:fc_stats_24/components/SkillHeader.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SkillsRating extends StatelessWidget {
  final Player skills;
  const SkillsRating({super.key, required this.skills});
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
        margin: const EdgeInsets.all(11),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
        decoration:
            BoxDecoration(border: Border.all(color: appColors.posColor)),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: appColors.posColor),
            child: const Text('SKILLS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          const SkillHeader(
            header: 'PACE',
          ),
          SkillCard(
            rating: skills.movementAcceleration,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Acceleration',
          ),
          SkillCard(
            rating: skills.movementSprintSpeed,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Sprint Speed',
          ),
          const SkillHeader(
            header: 'SHOOTING',
          ),
          SkillCard(
            rating: skills.mentalityPositioning,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Att. Positioning',
          ),
          SkillCard(
            rating: skills.attackingFinishing,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Finishing',
          ),
          SkillCard(
            rating: skills.powerShotPower,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Shot Power',
          ),
          SkillCard(
            rating: skills.powerLongShots,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Long Shots',
          ),
          SkillCard(
            rating: skills.attackingVolleys,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Volleys',
          ),
          SkillCard(
            rating: skills.mentalityPenalties,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Penalties',
          ),
          const SkillHeader(
            header: 'PASSING',
          ),
          SkillCard(
            rating: skills.mentalityVision,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Vision',
          ),
          SkillCard(
            rating: skills.attackingCrossing,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Crossing',
          ),
          SkillCard(
            rating: skills.skillFkAccuracy,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Free Kick Accuracy',
          ),
          SkillCard(
            rating: skills.attackingShortPassing,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Short Passing',
          ),
          SkillCard(
            rating: skills.skillLongPassing,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Long Passing',
          ),
          SkillCard(
            rating: skills.skillCurve,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Curve',
          ),
          const SkillHeader(
            header: 'DRIBBLING',
          ),
          SkillCard(
            rating: skills.movementAgility,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Agility',
          ),
          SkillCard(
            rating: skills.movementBalance,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Balance',
          ),
          SkillCard(
            rating: skills.movementReactions,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Reactions',
          ),
          SkillCard(
            rating: skills.skillBallControl,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Ball Control',
          ),
          SkillCard(
            rating: skills.skillDribbling,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Dribbling',
          ),
          SkillCard(
            rating: skills.mentalityComposure,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Composure',
          ),
          const SkillHeader(
            header: 'DEFENDING',
          ),
          SkillCard(
            rating: skills.mentalityInterceptions,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Interceptions',
          ),
          SkillCard(
            rating: skills.attackingHeadingAccuracy,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Heading Accuracy',
          ),
          SkillCard(
            rating: skills.defendingMarkingAwareness,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Marking',
          ),
          SkillCard(
            rating: skills.defendingStandingTackle,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Standing Tackle',
          ),
          SkillCard(
            rating: skills.defendingSlidingTackle,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Sliding Tackle',
          ),
          SkillCard(
            rating: skills.powerJumping,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Jumping',
          ),
          const SkillHeader(
            header: 'PHYSICAL',
          ),
          SkillCard(
            rating: skills.powerStamina,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Stamina',
          ),
          SkillCard(
            rating: skills.powerStrength,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Strength',
          ),
          SkillCard(
            rating: skills.mentalityAggression,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Aggression',
          ),
          const SkillHeader(
            header: 'GOALKEEPING',
          ),
          SkillCard(
            rating: skills.goalkeepingDiving,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Diving',
          ),
          SkillCard(
            rating: skills.goalkeepingHandling,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Handling',
          ),
          SkillCard(
            rating: skills.goalkeepingKicking,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Kicking',
          ),
          SkillCard(
            rating: skills.goalkeepingReflexes,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Reflexes',
          ),
          SkillCard(
            rating: skills.goalkeepingSpeed,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Speed',
          ),
          SkillCard(
            rating: skills.goalkeepingPositioning,
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Positioning',
          ),
        ]));
  }
}
