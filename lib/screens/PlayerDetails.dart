import 'package:fc_stats_24/config_ads.dart';
import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:fc_stats_24/providers/favorites_provider.dart';
import 'package:fc_stats_24/ads/ad_helper.dart';
import 'package:fc_stats_24/components/ClubDetails.dart';
import 'package:fc_stats_24/ads/MediumNativeAd.dart';
import 'package:fc_stats_24/components/GameAttributes.dart';
import 'package:fc_stats_24/components/PlayerDetailsRatingCard.dart';
import 'package:fc_stats_24/components/SkillsRating.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerDetails extends ConsumerStatefulWidget {
  final Player player;
  final int count;
  const PlayerDetails({super.key, required this.player, required this.count});

  @override
  ConsumerState<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends ConsumerState<PlayerDetails> {
  bool loading = true;
  Player? playerDetails;
  InterstitialAd? _interstitialAd;
  @override
  void initState() {
    super.initState();
    ref.read(videoAdProvider);
    if (showAds && widget.count % 5 == 0) {
      addInterstitialAd();
    }
    getPlayerData();
  }

  void addInterstitialAd() async {
    InterstitialAd.load(
        adUnitId: AdHelper.videoAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
            _interstitialAd!.show();
            ref.read(videoAdProvider.notifier).increment();
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  void getPlayerData() async {
    if (widget.player.id == null) return;

    setState(() {
      loading = true;
    });
    var det =
        await PlayersDatabase.instance.getPlayerDetails(widget.player.id!);
    setState(() {
      playerDetails = det;
      loading = false;
    });
  }

  void addToFavourites() async {
    if (widget.player.id == null) return;
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.player.id!);
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.player.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.shortName ?? "Player Details"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.star_border_rounded,
              color: isFav ? Colors.amber : Colors.white,
              size: 32,
            ),
            onPressed: () {
              addToFavourites();
            },
          )
        ],
      ),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: !loading && playerDetails != null
                    ? Column(
                        children: [
                          PlayerDetailsRatingCard(
                            playerData: playerDetails!,
                          ),
                          ClubDetails(
                            clubData: playerDetails!,
                          ),
                          if (showAds) const MediumNativeAd(),
                          GameAttributes(
                            gameData: playerDetails!,
                          ),
                          SkillsRating(
                            skills: playerDetails!,
                          )
                        ],
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Loading Details...'),
                        ),
                      ))),
      ]),
    );
  }
}
