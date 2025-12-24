import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class AttributeRating extends StatelessWidget {
  final num? attribute;
  final String heading;
  final double cardWidth;

  const AttributeRating({
    super.key,
    required this.heading,
    this.attribute,
    required this.cardWidth,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (attribute == null) return Colors.grey;
    if (attribute! >= 90) {
      return appColors.darkGreen;
    } else if (attribute! >= 80) {
      return appColors.green;
    } else if (attribute! >= 70) {
      return appColors.lightGreen;
    } else if (attribute! >= 50) {
      return appColors.yellow;
    } else {
      return appColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(heading),
        const SizedBox(height: 2.5),
        Container(
          width: queryData.size.width * cardWidth,
          height: queryData.size.width * cardWidth,
          decoration: BoxDecoration(color: bgColor(context)),
          child: Center(
            child: Text(
              attribute?.toInt().toString() ?? "-",
              style: const TextStyle(
                  fontSize: AppLayout.playerDetailsRatingFont,
                  fontWeight: AppLayout.ratingFontWeight),
            ),
          ),
        )
      ],
    );
  }
}
