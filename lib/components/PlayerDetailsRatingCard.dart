import 'package:fc_stats_24/components/AgeRating.dart';
import 'package:fc_stats_24/components/FootDetails.dart';
import 'package:fc_stats_24/components/OverallRating.dart';
import 'package:fc_stats_24/components/PotentialRating.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class PlayerDetailsRatingCard extends StatelessWidget {
  final playerData;
  const PlayerDetailsRatingCard({super.key, this.playerData});

  String playerPositions() {
    String pos = playerData['player_positions'];
    List li = pos.split(",");
    String p = "";
    for (int i = 0; i < li.length; i++) {
      p += li[i];
      p += " ";
    }
    return p;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double remWidth = width - 24;
    return Container(
      margin: const EdgeInsets.all(11),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
      decoration: BoxDecoration(border: Border.all(color: posColor)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: posColor),
            child: const Text('PLAYER DETAILS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                              overall: playerData['overall'],
                              cardWidth: detailsPageWidth,
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
                              age: playerData['age'],
                              cardWidth: detailsPageWidth,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  //decoration: BoxDecoration(color: Colors.green),
                  width: remWidth * 0.35,
                  height: remWidth * 0.38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          playerPositions(),
                          style: TextStyle(
                              color: posColor,
                              fontWeight: posDetFontWeight,
                              fontSize: posFontSize),
                        ),
                      ),
                      SizedBox(
                        height: remWidth * 0.32,
                        width: remWidth * 0.32,
                        child: Image.network(
                          playerData['player_face_url'],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image loaded successfully
                              return child;
                            } else if (loadingProgress.cumulativeBytesLoaded ==
                                loadingProgress.expectedTotalBytes) {
                              // Image failed to load
                              return Image.asset(
                                  'assets/images/player_icon.webp',
                                  fit: BoxFit.fitWidth);
                            } else {
                              // Image still loading
                              return Image.asset(
                                  'assets/images/player_icon.webp',
                                  fit: BoxFit.fitWidth);
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Handle image loading error
                            return Image.asset('assets/images/player_icon.webp',
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
                              potential: playerData['potential'],
                              cardWidth: detailsPageWidth,
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
                              foot: playerData['preferred_foot'],
                              cardWidth: detailsPageWidth,
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
              playerData['long_name'],
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
                playerData['nation_flag_url'].length > 0
                    ? SizedBox(
                        width: 0.045 * remWidth,
                        child: Image.network(
                          playerData['nation_flag_url'],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image loaded successfully
                              return child;
                            } else if (loadingProgress.cumulativeBytesLoaded ==
                                loadingProgress.expectedTotalBytes) {
                              // Image failed to load
                              return Image.asset('assets/images/icon.png',
                                  fit: BoxFit.fitWidth);
                            } else {
                              // Image still loading
                              return Image.asset('assets/images/icon.png',
                                  fit: BoxFit.fitWidth);
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Handle image loading error
                            return Image.asset('assets/images/icon.png',
                                fit: BoxFit.fitWidth);
                          },
                        ),
                      )
                    : Container(width: 0.045 * remWidth),
                Container(
                  child: const Text(' '),
                ),
                Container(
                  child: Text(
                    playerData['nationality_name'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  child: const Text(' - '),
                ),
                Container(
                  child: Text(
                    playerData['dob'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  child: const Text(' - '),
                ),
                Container(
                  child: Text(
                    '${playerData['height_cm']} cm',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  child: const Text(' - '),
                ),
                Container(
                  child: Text(
                    '${playerData['weight_kg']} kg',
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 5,
          ),
          Container(
            child: Row(
              children: [
                SizedBox(
                  width: 0.5 * remWidth,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'REAL FACE: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(color: lightGreen, fontSize: 15),
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
                        playerData['club_jersey_number'] == 0
                            ? 'None'
                            : playerData['club_jersey_number'].toString(),
                        style: const TextStyle(color: lightGreen, fontSize: 15),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
