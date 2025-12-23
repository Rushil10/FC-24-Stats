import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:fc_stats_24/components/AgeRating.dart';
import 'package:fc_stats_24/components/OverallRating.dart';
import 'package:fc_stats_24/components/PotentialRating.dart';
import 'package:fc_stats_24/screens/PlayerDetails.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerCard extends ConsumerStatefulWidget {
  final playerData;
  const PlayerCard({super.key, this.playerData});

  @override
  ConsumerState<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends ConsumerState<PlayerCard> {
  @override
  void initState() {
    super.initState();
    ref.read(videoAdProvider);
  }

  String playerPositions() {
    String pos = widget.playerData['player_positions'];
    List li = pos.split(",");
    String p = "";
    for (int i = 0; i < li.length; i++) {
      p += li[i];
      p += " ";
    }
    return p;
  }

  void onTapPlayer(var count) {
    ref.read(videoAdProvider.notifier).increment();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PlayerDetails(player: widget.playerData, count: count)));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final count = ref.watch(videoAdProvider);
        //print(count);
        onTapPlayer(count);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
        child: Row(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OverallRating(
                    overall: widget.playerData['overall'],
                    cardWidth: mainPageWidth,
                  ),
                  Container(
                    width: queryData.size.width * 0.01,
                  ),
                  PotentialRating(
                    potential: widget.playerData['potential'],
                    cardWidth: mainPageWidth,
                  ),
                  Container(
                    width: queryData.size.width * 0.01,
                  ),
                  AgeRating(
                    age: widget.playerData['age'],
                    cardWidth: mainPageWidth,
                  ),
                  Container(
                    width: queryData.size.width * 0.02,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.playerData['short_name'],
                    style: TextStyle(
                        fontSize: ratingCardFont, fontWeight: ratingCardWeight),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    playerPositions(),
                    style: TextStyle(
                        color: posColor,
                        fontWeight: posFontWeight,
                        fontSize: clubNameFontSize),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: queryData.size.width / 2.1),
                    child: Text(
                      widget.playerData['club_name'].length > 0
                          ? widget.playerData['club_name']
                          : "Free Agent",
                      style: TextStyle(
                          color: clubNameColor, fontSize: clubNameFontSize),
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: Container()),
            SizedBox(
              width: queryData.size.width * 0.11,
              height: queryData.size.width * 0.11,
              child: Image.network(
                widget.playerData['player_face_url'],
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // Image loaded successfully
                    return child;
                  } else if (loadingProgress.cumulativeBytesLoaded ==
                      loadingProgress.expectedTotalBytes) {
                    // Image failed to load
                    return Image.asset('assets/images/player_icon.webp',
                        fit: BoxFit.fitWidth);
                  } else {
                    // Image still loading
                    return Image.asset('assets/images/player_icon.webp',
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
    );
  }
}
