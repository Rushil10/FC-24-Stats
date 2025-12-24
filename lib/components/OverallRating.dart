import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class OverallRating extends StatelessWidget {
  final num? overall;
  final double cardWidth;

  const OverallRating({
    super.key,
    this.overall,
    required this.cardWidth,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (overall == null) return Colors.grey;
    if (overall! >= 90) {
      return appColors.darkGreen;
    } else if (overall! >= 80) {
      return appColors.green;
    } else if (overall! >= 70) {
      return appColors.lightGreen;
    } else if (overall! >= 50) {
      return appColors.yellow;
    } else {
      return appColors.red;
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
          overall?.toInt().toString() ?? "-",
          style: const TextStyle(
              fontSize: AppLayout.ratingFont,
              fontWeight: AppLayout.ratingFontWeight),
        ),
      ),
    );
  }
}
