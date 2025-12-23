import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class OverallRating extends StatelessWidget {
  final overall;
  final cardWidth;
  const OverallRating({super.key, this.overall, this.cardWidth});

  Color bgColor() {
    if (overall >= 90) {
      const color = darkGreen;
      return color;
    } else if (overall >= 80) {
      const color = green;
      return color;
    } else if (overall >= 70) {
      const color = lightGreen;
      return color;
    } else if (overall >= 50) {
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
      width: queryData.size.width * cardWidth,
      height: queryData.size.width * cardWidth,
      decoration: BoxDecoration(color: bgColor()),
      child: Center(
        child: Text(
          overall.toString(),
          style: TextStyle(fontSize: ratingFont, fontWeight: ratingFontWeight),
        ),
      ),
    );
  }
}
