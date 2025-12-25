import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class ClubDetails extends StatelessWidget {
  final Player clubData;
  const ClubDetails({super.key, required this.clubData});

  String convertWage(num? val) {
    if (val == null || val == 0) {
      return "-";
    }
    var valStr = val.toInt().toString();
    var w = valStr.length;
    if (w >= 4 && w <= 6) {
      String v = '\u{20AC}${valStr.substring(0, w - 3)}';
      v += "K";
      return v;
    }
    if (w > 6) {
      String v = '\u{20AC}${valStr.substring(0, w - 6)}';
      v += "M";
      return v;
    }
    return '\u{20AC}$valStr';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.all(11),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
      decoration: BoxDecoration(border: Border.all(color: appColors.posColor)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: appColors.posColor),
            child: const Text('CLUB DETAILS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          if (clubData.clubLogoUrl != null && clubData.clubLogoUrl!.isNotEmpty)
            Center(
              child: SizedBox(
                width: 0.15 * width,
                height: 0.15 * width,
                child: Image.network(
                  clubData.clubLogoUrl!,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset('assets/common/icon.png',
                        fit: BoxFit.fitWidth);
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/common/icon.png',
                        fit: BoxFit.fitWidth);
                  },
                ),
              ),
            ),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                clubData.clubName ?? "Free Agent",
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                clubData.leagueName ?? "N/A",
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                clubData.clubJoined ?? "N/A",
                style: const TextStyle(fontSize: 15),
              ),
              const Text(
                ' - ',
                style: TextStyle(fontSize: 15),
              ),
              const Text(
                'Contract Until: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                clubData.clubContractValidUntil?.toString() ?? "N/A",
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
          Container(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Wage',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData.wageEur),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
              Container(
                width: 15,
              ),
              Column(
                children: [
                  const Text(
                    'Value',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData.valueEur),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
              Container(
                width: 15,
              ),
              Column(
                children: [
                  const Text(
                    'Clause',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData.releaseClauseEur),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
