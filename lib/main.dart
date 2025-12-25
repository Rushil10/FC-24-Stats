import 'package:fc_stats_24/ads/BannerAdSmall.dart';
import 'package:fc_stats_24/config_ads.dart';
import 'package:flutter/services.dart';
import 'package:fc_stats_24/screens/SetUpLocalDb.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:fc_stats_24/ads/InterstitialAdManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  if (showAds) {
    MobileAds.instance.initialize();
    InterstitialAdManager().loadAd();
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeClass.darkTheme,
      theme: ThemeClass.lightTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) {
            if (showAds) {
              InterstitialAdManager().recordInteraction();
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                Expanded(child: child!),
                if (showAds) const BannerSmallAd(),
              ],
            ),
          ),
        );
      },
      home: const SetUpLocalDb(),
    );
  }
}
