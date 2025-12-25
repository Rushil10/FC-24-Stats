import 'package:fc_stats_24/components/AgeRating.dart';
import 'package:fc_stats_24/components/FootDetails.dart';
import 'package:fc_stats_24/components/OverallRating.dart';
import 'package:fc_stats_24/components/PotentialRating.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class PlayerDetailsRatingCard extends StatelessWidget {
  final Player playerData;
  const PlayerDetailsRatingCard({super.key, required this.playerData});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double remWidth = width - 24;

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
            child: const Text('PLAYER DETAILS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
            child: Row(
              children: [
                SizedBox(
                  width: remWidth * 0.32,
                  height: 0.38 * remWidth,
                  child: Column(
                    children: [
                      Container(
                        height: 0.19 * remWidth,
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            const Text(
                              'OVR',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            OverallRating(
                              overall: playerData.overall,
                              cardWidth: AppLayout.detailsPageWidth,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 0.19 * remWidth,
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'AGE',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            AgeRating(
                              age: playerData.age,
                              cardWidth: AppLayout.detailsPageWidth,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: remWidth * 0.35,
                  height: remWidth * 0.38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        playerData.formattedPositions,
                        style: TextStyle(
                            color: appColors.posColor,
                            fontWeight: AppLayout.posDetFontWeight,
                            fontSize: AppLayout.posFontSize),
                      ),
                      SizedBox(
                        height: remWidth * 0.32,
                        width: remWidth * 0.32,
                        child: Image.network(
                          playerData.playerFaceUrl ?? "",
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Image.asset(
                                  'assets/common/player_icon.webp',
                                  fit: BoxFit.fitWidth);
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/common/player_icon.webp',
                                fit: BoxFit.fitWidth);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: remWidth * 0.32,
                  height: remWidth * 0.38,
                  child: Column(
                    children: [
                      Container(
                        height: 0.19 * remWidth,
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            const Text(
                              'POT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            PotentialRating(
                              potential: playerData.potential,
                              cardWidth: AppLayout.detailsPageWidth,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 0.19 * remWidth,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'FOOT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            FootDetails(
                              foot: playerData.preferredFoot,
                              cardWidth: AppLayout.detailsPageWidth,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Text(
              playerData.longName ?? "Unknown Player",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            height: 3,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (playerData.nationFlagUrl != null &&
                    playerData.nationFlagUrl!.isNotEmpty)
                  SizedBox(
                    width: 0.045 * remWidth,
                    child: Image.network(
                      playerData.nationFlagUrl!,
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
                  )
                else
                  Container(width: 0.045 * remWidth),
                const Text(' '),
                Text(
                  playerData.nationalityName ?? "N/A",
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(' - '),
                Text(
                  playerData.dob ?? "N/A",
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(' - '),
                Text(
                  '${playerData.heightCm ?? "-"} cm',
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(' - '),
                Text(
                  '${playerData.weightKg ?? "-"} kg',
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
          Container(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 0.5 * remWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'REAL FACE: ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      playerData.realFace == '1' ||
                              playerData.realFace == 'true'
                          ? 'Yes'
                          : 'No',
                      style:
                          TextStyle(color: appColors.lightGreen, fontSize: 15),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 0.5 * remWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Jersey: ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      playerData.clubJerseyNumber == null ||
                              playerData.clubJerseyNumber == 0
                          ? 'None'
                          : playerData.clubJerseyNumber.toString(),
                      style:
                          TextStyle(color: appColors.lightGreen, fontSize: 15),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
