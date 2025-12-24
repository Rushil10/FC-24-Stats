import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SkillHeader extends StatelessWidget {
  final String header;
  const SkillHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: appColors.posColor),
      child: Text(header,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
    );
  }
}
