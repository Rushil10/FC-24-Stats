import 'package:fc_stats_24/components/AgeRating.dart';
import 'package:fc_stats_24/components/OverallRating.dart';
import 'package:fc_stats_24/components/PotentialRating.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/screens/PlayerDetails.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerCard extends ConsumerStatefulWidget {
  final Player playerData;
  final VoidCallback? onTap;

  const PlayerCard({super.key, required this.playerData, this.onTap});

  @override
  ConsumerState<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends ConsumerState<PlayerCard> {
  void onTapPlayer() {
    if (kDebugMode) {
      print("${widget.playerData.shortName} card tapped");
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlayerDetails(
              player: widget.playerData,
            )));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          onTapPlayer();
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OverallRating(
                  overall: widget.playerData.overall,
                  cardWidth: AppLayout.mainPageWidth,
                ),
                SizedBox(
                  width: queryData.size.width * 0.01,
                ),
                PotentialRating(
                  potential: widget.playerData.potential,
                  cardWidth: AppLayout.mainPageWidth,
                ),
                SizedBox(
                  width: queryData.size.width * 0.01,
                ),
                AgeRating(
                  age: widget.playerData.age,
                  cardWidth: AppLayout.mainPageWidth,
                ),
                SizedBox(
                  width: queryData.size.width * 0.02,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints:
                      BoxConstraints(maxWidth: queryData.size.width / 2.3),
                  child: Text(
                    widget.playerData.shortName ?? "Unknown",
                    style: const TextStyle(
                        fontSize: AppLayout.ratingCardFont,
                        fontWeight: AppLayout.ratingCardWeight,
                        height: 1.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  widget.playerData.formattedPositions,
                  style: TextStyle(
                      color: appColors.posColor,
                      fontWeight: AppLayout.posFontWeight,
                      fontSize: AppLayout.clubNameFontSize,
                      height: 1.2),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxWidth: queryData.size.width / 2.3),
                  child: Text(
                    widget.playerData.clubName ?? "Free Agent",
                    style: TextStyle(
                        color: appColors.clubNameColor,
                        fontSize: AppLayout.clubNameFontSize,
                        height: 1.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            SizedBox(
              width: queryData.size.width * 0.11,
              height: queryData.size.width * 0.11,
              child: Image.network(
                widget.playerData.playerFaceUrl ?? "",
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Image.asset('assets/images/player_icon.webp',
                        fit: BoxFit.contain);
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/player_icon.webp',
                      fit: BoxFit.contain);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
