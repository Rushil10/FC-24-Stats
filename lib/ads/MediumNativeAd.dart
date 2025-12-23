import 'package:fc_stats_24/ads/ad_helper.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MediumNativeAd extends StatefulWidget {
  const MediumNativeAd({super.key});

  @override
  _MediumNativeAdState createState() => _MediumNativeAdState();
}

class _MediumNativeAdState extends State<MediumNativeAd> {
  late NativeAd _adMedium;
  bool _isAdLoadedMedium = false;

  @override
  void initState() {
    super.initState();
    getNativeAdd();
  }

  void getNativeAdd() async {
    _adMedium = NativeAd(
      // Here in adUnitId: add your own ad unit ID before release build

      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTileMedium',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoadedMedium = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _adMedium.load();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.all(11),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(border: Border.all(color: posColor)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: posColor),
              child: const Text('Sponsored Ad',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
            ),
            _isAdLoadedMedium
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: width - 35,
                      width: width - 35,
                      child: AdWidget(ad: _adMedium),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: CircularProgressIndicator(),
                    ))
          ],
        ));
  }
}
