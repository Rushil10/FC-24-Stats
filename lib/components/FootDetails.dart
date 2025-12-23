import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class FootDetails extends StatelessWidget {
  final foot;
  final cardWidth;
  const FootDetails({super.key, this.cardWidth, this.foot});

  Color bgColor(BuildContext context) {
    // Both Left/Right seem to use yellow in original code
    final appColors = Theme.of(context).extension<AppColors>()!;
    return appColors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      width: queryData.size.width * cardWidth,
      height: queryData.size.width * cardWidth,
      decoration: BoxDecoration(color: bgColor(context)),
      child: Center(
        child: Text(
          foot != null && foot.toString().isNotEmpty ? foot[0].toString() : "-",
          style: const TextStyle(
              fontSize: AppLayout.ratingFont,
              color: Colors.black,
              fontWeight: AppLayout.ratingFontWeight),
        ),
      ),
    );
  }
}
