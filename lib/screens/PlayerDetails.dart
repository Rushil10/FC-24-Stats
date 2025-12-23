import 'package:fc_stats_24/config_ads.dart';
import 'package:fc_stats_24/State/VideoAdState.dart';

import 'package:fc_stats_24/ads/BannerAdSmall.dart';
import 'package:fc_stats_24/ads/ad_helper.dart';
import 'package:fc_stats_24/components/ClubDetails.dart';
import 'package:fc_stats_24/ads/MediumNativeAd.dart';
import 'package:fc_stats_24/components/GameAttributes.dart';
import 'package:fc_stats_24/components/PlayerDetailsRatingCard.dart';
import 'package:fc_stats_24/components/SkillsRating.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerDetails extends ConsumerStatefulWidget {
  final player;
  final count;
  const PlayerDetails({super.key, this.player, this.count});

  @override
  _PlayerDetailsState createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends ConsumerState<PlayerDetails> {
  @override
  var loading = true;
  var playerDetails = {};
  InterstitialAd? _interstitialAd;
  bool fav = false;

  @override
  void initState() {
    super.initState();
    ref.read(videoAdProvider);
    if (SHOW_ADS && widget.count % 5 == 0) {
      addInterstitialAd();
    }
    getPlayerData();
    checkIfFav();
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
    setState(() {
      loading = true;
    });
    var det =
        await PlayersDatabase.instance.getPlayerDetails(widget.player['id']);
    setState(() {
      playerDetails = det[0];
      loading = false;
    });
  }

  void checkIfFav() async {
    bool f = await PlayersDatabase.instance.checkFav(widget.player['id']);
    setState(() {
      fav = f;
    });
  }

  void addToFavourites() async {
    await PlayersDatabase.instance.searchFavourites(widget.player['id']);
    setState(() {
      fav = !fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player['short_name']),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.star_border_rounded,
              color: fav ? Colors.amber : Colors.white,
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
                child: !loading
                    ? Column(
                        children: [
                          PlayerDetailsRatingCard(
                            playerData: playerDetails,
                          ),
                          ClubDetails(
                            clubData: playerDetails,
                          ),
                          if (SHOW_ADS) const MediumNativeAd(),
                          GameAttributes(
                            gameData: playerDetails,
                          ),
                          SkillsRating(
                            skills: playerDetails,
                          )
                        ],
                      )
                    : Center(
                        child: Container(
                          child: const Text('Loading'),
                        ),
                      ))),
        if (SHOW_ADS) BannerSmallAd(),
      ]),
    );
  }
}
