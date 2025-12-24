import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class PotentialRating extends StatelessWidget {
  final num? potential;
  final double cardWidth;

  const PotentialRating({
    super.key,
    this.potential,
    required this.cardWidth,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (potential == null) return Colors.grey;
    if (potential! >= 90) {
      return appColors.darkGreen;
    } else if (potential! >= 80) {
      return appColors.green;
    } else if (potential! >= 70) {
      return appColors.lightGreen;
    } else if (potential! >= 50) {
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
          potential?.toInt().toString() ?? "-",
          style: const TextStyle(
              fontSize: AppLayout.ratingFont,
              fontWeight: AppLayout.ratingFontWeight),
        ),
      ),
    );
  }
}
