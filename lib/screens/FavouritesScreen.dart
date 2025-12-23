import 'package:fc_stats_24/ads/ad_helper.dart';
import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/ads/BannerAdSmall.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:fc_stats_24/config_ads.dart';

class Favourites extends ConsumerStatefulWidget {
  final type;
  final title;
  final count;
  const Favourites({super.key, this.type, this.title, this.count});

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  var loading = true;
  var players = [];
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    if (widget.type == "Fav") {
      getFavouritePlayers();
    }
    if (widget.type == "Young") {
      getYoungPlayers();
    }
    if (widget.type == "Free") {
      getAllFreePlayers();
    }
    if (SHOW_ADS && widget.count % 5 == 0) {
      addInterstitialAd();
    }
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

  void getFavouritePlayers() async {
    var all = await PlayersDatabase.instance.getFavourites();
    setState(() {
      players = all;
      loading = false;
    });
  }

  void getAllFreePlayers() async {
    var all = await PlayersDatabase.instance.getFreeAgents();
    setState(() {
      players = all;
      loading = false;
    });
  }

  void getYoungPlayers() async {
    var all = await PlayersDatabase.instance.getYoungPlayers();
    setState(() {
      players = all;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: !loading
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'OVR',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'POT',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'AGE',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return PlayerCard(
                              playerData: players[index],
                            );
                          })),
                  if (SHOW_ADS) BannerSmallAd(),
                ],
              )
            : Center(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    color: appColors.posColor,
                  ),
                ),
              ));
  }
}
