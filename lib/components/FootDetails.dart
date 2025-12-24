import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class FootDetails extends StatelessWidget {
  final String? foot;
  final double cardWidth;

  const FootDetails({
    super.key,
    required this.cardWidth,
    required this.foot,
  });

  Color bgColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return appColors.yellow;
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
          foot != null && foot!.isNotEmpty ? foot![0] : "-",
          style: const TextStyle(
              fontSize: AppLayout.ratingFont,
              color: Colors.black,
              fontWeight: AppLayout.ratingFontWeight),
        ),
      ),
    );
  }
}
