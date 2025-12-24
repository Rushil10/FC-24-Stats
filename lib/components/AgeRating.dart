import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class AgeRating extends StatelessWidget {
  final num? age;
  final double cardWidth;

  const AgeRating({
    super.key,
    this.age,
    required this.cardWidth,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (age == null) return Colors.grey;
    if (age! >= 35) {
      return appColors.red;
    } else if (age! >= 30) {
      return appColors.yellow;
    } else if (age! >= 25) {
      return appColors.lightGreen;
    } else if (age! >= 20) {
      return appColors.green;
    } else {
      return appColors.darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Container(
      width: queryData.size.width * cardWidth,
      height: queryData.size.width * cardWidth,
      decoration: BoxDecoration(color: bgColor(context)),
      child: Center(
        child: Text(
          age?.toInt().toString() ?? "-",
          style: const TextStyle(
              fontSize: AppLayout.ratingFont,
              fontWeight: AppLayout.ratingFontWeight),
        ),
      ),
    );
  }
}
