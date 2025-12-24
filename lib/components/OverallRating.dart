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
    final rating = overall?.toDouble() ?? 0.0;
    if (overall == null) return Colors.grey;

    if (rating >= 90) return appColors.darkGreen;
    if (rating >= 80) return appColors.green;
    if (rating >= 70) return appColors.lightGreen;
    if (rating >= 50) return appColors.yellow;
    return appColors.red;
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
