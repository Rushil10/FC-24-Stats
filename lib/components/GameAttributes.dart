import 'package:fc_stats_24/components/AttributeRating.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class GameAttributes extends StatelessWidget {
  final Player gameData;
  const GameAttributes({super.key, required this.gameData});

  Color workRateColor(String rate, AppColors appColors) {
    if (rate == "High") {
      return appColors.darkGreen;
    } else if (rate == "Medium") {
      return appColors.yellow;
    } else {
      return appColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> playerTraits = gameData.traitsList;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
        margin: const EdgeInsets.all(11),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
        decoration:
            BoxDecoration(border: Border.all(color: appColors.posColor)),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: appColors.posColor),
            child: const Text('GAME ATTRIBUTES',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 9, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Skill Moves'),
                        Row(
                          children: [
                            Text(gameData.skillMoves?.toString() ?? "0"),
                            const Text(' '),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                              size: 15,
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Weak Foot'),
                        Row(
                          children: [
                            Text(gameData.weakFoot?.toString() ?? "0"),
                            const Text(' '),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                              size: 15,
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Reputation'),
                        Row(
                          children: [
                            Text(gameData.internationalReputation?.toString() ??
                                "0"),
                            const Text(' '),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                              size: 15,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Work Rates (Att)'),
                        Text(
                          gameData.shootingWorkRate,
                          style: TextStyle(
                              color: workRateColor(
                                  gameData.shootingWorkRate, appColors)),
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Work Rates (Def)'),
                        Text(
                          gameData.defensiveWorkRate,
                          style: TextStyle(
                              color: workRateColor(
                                  gameData.defensiveWorkRate, appColors)),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AttributeRating(
                      heading: 'PAC',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.pace,
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'SHO',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.shooting,
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'PAS',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.passing,
                    ),
                  ],
                ),
                Container(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AttributeRating(
                      heading: 'DRI',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.dribbling,
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'PHY',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.physic,
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'DEF',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData.defending,
                    ),
                  ],
                ),
                Container(
                  height: 9,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 9),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: appColors.posColor),
                  child: const Text('Traits',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                ),
                if (playerTraits.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: playerTraits.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(playerTraits[index]),
                        );
                      })
                else
                  const Center(child: Text('No traits available')),
              ],
            ),
          )
        ]));
  }
}
