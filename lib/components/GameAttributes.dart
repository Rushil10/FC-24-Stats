import 'package:fc_stats_24/components/AttributeRating.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class GameAttributes extends StatelessWidget {
  final gameData;
  const GameAttributes({super.key, this.gameData});

  String workRateAtt() {
    var work = gameData['work_rate'];
    List<String> wr = work.split('/');
    return wr[0];
  }

  String workRateDef() {
    var work = gameData['work_rate'];
    List<String> wr = work.split('/');
    return wr[1];
  }

  Color workRateColor(var rate, AppColors appColors) {
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
    List<String> playerTraits = gameData['player_traits'].split(',');
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
            child: const Text('CLUB DETAILS',
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
                            Text(gameData['skill_moves'].toString()),
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
                            Text(gameData['weak_foot'].toString()),
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
                            Text(gameData['international_reputation']
                                .toString()),
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
                          workRateAtt(),
                          style: TextStyle(
                              color: workRateColor(workRateAtt(), appColors)),
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
                          workRateDef(),
                          style: TextStyle(
                              color: workRateColor(workRateDef(), appColors)),
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
                      attribute: gameData['pace'],
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'SHO',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData['shooting'],
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'PAS',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData['passing'],
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
                      attribute: gameData['dribbling'],
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'PHY',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData['physic'],
                    ),
                    Container(
                      width: 15,
                    ),
                    AttributeRating(
                      heading: 'DEF',
                      cardWidth: AppLayout.ratingWidthDetails,
                      attribute: gameData['defending'],
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
              ],
            ),
          )
        ]));
  }
}
