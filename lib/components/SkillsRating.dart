import 'package:fc_stats_24/components/SkillCard.dart';
import 'package:fc_stats_24/components/SkillHeader.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SkillsRating extends StatelessWidget {
  final skills;
  const SkillsRating({super.key, this.skills});
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
            rating: skills['movement_acceleration'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Acceleration',
          ),
          SkillCard(
            rating: skills['movement_sprint_speed'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Sprint Speed',
          ),
          const SkillHeader(
            header: 'SHOOTING',
          ),
          SkillCard(
            rating: skills['mentality_positioning'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Att. Posistioning',
          ),
          SkillCard(
            rating: skills['attacking_finishing'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Finishing',
          ),
          SkillCard(
            rating: skills['power_shot_power'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Shot Power',
          ),
          SkillCard(
            rating: skills['power_long_shots'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Long Shots',
          ),
          SkillCard(
            rating: skills['attacking_volleys'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Volleys',
          ),
          SkillCard(
            rating: skills['mentality_penalties'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Penalties',
          ),
          const SkillHeader(
            header: 'PASSING',
          ),
          SkillCard(
            rating: skills['mentality_vision'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Vision',
          ),
          SkillCard(
            rating: skills['attacking_crossing'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Crossing',
          ),
          SkillCard(
            rating: skills['skill_fk_accuracy'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Free Kick Accuracy',
          ),
          SkillCard(
            rating: skills['attacking_short_passing'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Short Passing',
          ),
          SkillCard(
            rating: skills['skill_long_passing'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Long Passing',
          ),
          SkillCard(
            rating: skills['skill_curve'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Curve',
          ),
          const SkillHeader(
            header: 'DRIBBLING',
          ),
          SkillCard(
            rating: skills['movement_agility'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Agility',
          ),
          SkillCard(
            rating: skills['movement_balance'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Balance',
          ),
          SkillCard(
            rating: skills['movement_reactions'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Reactions',
          ),
          SkillCard(
            rating: skills['skill_ball_control'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Ball Control',
          ),
          SkillCard(
            rating: skills['skill_dribbling'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Dribbling',
          ),
          SkillCard(
            rating: skills['mentality_composure'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Composure',
          ),
          const SkillHeader(
            header: 'DEFENDING',
          ),
          SkillCard(
            rating: skills['mentality_interceptions'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Interceptions',
          ),
          SkillCard(
            rating: skills['attacking_heading_accuracy'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Heading Accuracy',
          ),
          SkillCard(
            rating: skills['defending_marking_awareness'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Marking',
          ),
          SkillCard(
            rating: skills['defending_standing_tackle'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Standing Tackle',
          ),
          SkillCard(
            rating: skills['defending_sliding_tackle'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Sliding Tackle',
          ),
          SkillCard(
            rating: skills['power_jumping'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Jumping',
          ),
          const SkillHeader(
            header: 'PHYSICAL',
          ),
          SkillCard(
            rating: skills['power_stamina'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Stamina',
          ),
          SkillCard(
            rating: skills['power_strength'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Strength',
          ),
          SkillCard(
            rating: skills['mentality_aggression'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Aggression',
          ),
          const SkillHeader(
            header: 'GOALKEEPING',
          ),
          SkillCard(
            rating: skills['goalkeeping_diving'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Diving',
          ),
          SkillCard(
            rating: skills['goalkeeping_handling'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Handling',
          ),
          SkillCard(
            rating: skills['goalkeeping_kicking'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Kicking',
          ),
          SkillCard(
            rating: skills['goalkeeping_reflexes'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Reflexes',
          ),
          skills['goalkeeping_reflexes'].runtimeType == int
              ? SkillCard(
                  rating: skills['goalkeeping_reflexes'],
                  cardWidth: AppLayout.ratingWidthDetails,
                  skill: 'Speed',
                )
              : SkillCard(
                  rating: int.parse(skills['goalkeeping_reflexes']),
                  cardWidth: AppLayout.ratingWidthDetails,
                  skill: 'Speed',
                ),
          SkillCard(
            rating: skills['goalkeeping_positioning'],
            cardWidth: AppLayout.ratingWidthDetails,
            skill: 'Posistioning',
          ),
        ]));
  }
}
