import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final rating;
  final skill;
  final cardWidth;
  const SkillCard({super.key, this.rating, this.skill, this.cardWidth});

  Color bgColor() {
    if (rating == null) return Colors.grey;
    if (rating >= 90) {
      const color = darkGreen;
      return color;
    } else if (rating >= 80) {
      const color = green;
      return color;
    } else if (rating >= 70) {
      const color = lightGreen;
      return color;
    } else if (rating >= 50) {
      const color = yellow;
      return color;
    } else {
      const color = red;
      return color;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: queryData.size.width * cardWidth,
            height: queryData.size.width * cardWidth,
            decoration: BoxDecoration(color: bgColor()),
            child: Center(
              child: Text(
                rating?.toString() ?? "-",
                style: TextStyle(
                    fontSize: playerDetailsRatingFont,
                    fontWeight: ratingFontWeight),
              ),
            ),
          ),
          Container(
            width: 5,
          ),
          Text(
            skill,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
