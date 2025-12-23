import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class SkillHeader extends StatelessWidget {
  final header;
  const SkillHeader({super.key, this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: posColor),
      child: Text(header,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
    );
  }
}
