import 'package:fc_stats_24/components/AgeRating.dart';
import 'package:fc_stats_24/components/OverallRating.dart';
import 'package:fc_stats_24/components/PotentialRating.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/layout.dart';
import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:fc_stats_24/screens/PlayerDetails.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerCard extends ConsumerStatefulWidget {
  final Player playerData;

  const PlayerCard({super.key, required this.playerData});

  @override
  ConsumerState<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends ConsumerState<PlayerCard> {
  void onTapPlayer(int count) {
    if (kDebugMode) {
      print("${widget.playerData.shortName} card tapped");
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlayerDetails(
              player: widget.playerData,
              count: count,
            )));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final count = ref.read(videoAdProvider);
        onTapPlayer(count);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
        child: Row(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.playerData.shortName ?? "Unknown",
                    style: const TextStyle(
                        fontSize: AppLayout.ratingCardFont,
                        fontWeight: AppLayout.ratingCardWeight),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.playerData.formattedPositions,
                    style: TextStyle(
                        color: appColors.posColor,
                        fontWeight: AppLayout.posFontWeight,
                        fontSize: AppLayout.clubNameFontSize),
                  ),
                  Row(
                    children: [
                      if (widget.playerData.clubLogoUrl != null &&
                          widget.playerData.clubLogoUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.network(
                            widget.playerData.clubLogoUrl!,
                            width: 15,
                            height: 15,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      if (widget.playerData.nationFlagUrl != null &&
                          widget.playerData.nationFlagUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.network(
                            widget.playerData.nationFlagUrl!,
                            width: 15,
                            height: 10,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          widget.playerData.clubName ?? "Free Agent",
                          style: TextStyle(
                              color: appColors.clubNameColor,
                              fontWeight: AppLayout.clubNameFontWeight,
                              fontSize: AppLayout.clubNameFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: queryData.size.width * 0.15,
              height: queryData.size.width * 0.15,
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
