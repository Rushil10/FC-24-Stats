import 'ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerSmallAd extends StatefulWidget {
  const BannerSmallAd({super.key});

  @override
  State<BannerSmallAd> createState() => _BannerSmallAdState();
}

class _BannerSmallAdState extends State<BannerSmallAd> {
  late BannerAd _ad;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setUpBannerAd();
    //setUpDb();
  }

  void setUpBannerAd() async {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoading = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? SizedBox(
              width: _ad.size.width.toDouble(),
              height: _ad.size.height.toDouble(),
              child: AdWidget(ad: _ad),
              //alignment: Alignment.center,
            )
          : Container(),
    );
  }
}
