import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final num? rating;
  final String skill;
  final double cardWidth;

  const SkillCard({
    super.key,
    required this.rating,
    required this.skill,
    required this.cardWidth,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (rating == null) return Colors.grey;
    if (rating! >= 90) {
      return appColors.darkGreen;
    } else if (rating! >= 80) {
      return appColors.green;
    } else if (rating! >= 70) {
      return appColors.lightGreen;
    } else if (rating! >= 50) {
      return appColors.yellow;
    } else {
      return appColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: queryData.size.width * cardWidth,
            height: queryData.size.width * cardWidth,
            decoration: BoxDecoration(color: bgColor(context)),
            child: Center(
              child: Text(
                rating?.toInt().toString() ?? "-",
                style: const TextStyle(
                    fontSize: AppLayout.playerDetailsRatingFont,
                    fontWeight: AppLayout.ratingFontWeight),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            skill,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
