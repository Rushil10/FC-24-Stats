import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';
import '../config_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  int _clickCount = 0;
  final int _adThreshold =
      30; // Increased because we are tracking EVERY touch now

  // Singleton pattern
  static final InterstitialAdManager _instance =
      InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  /// Load an ad so it's ready when needed
  void loadAd() {
    if (!showAds) return;

    InterstitialAd.load(
      adUnitId: AdHelper.videoAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd(); // Preload the next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Record a click/interaction and show ad if threshold reached
  void recordInteraction() {
    if (!showAds) return;

    _clickCount++;
    if (_clickCount >= _adThreshold) {
      _showAd();
      _clickCount = 0; // Reset counter
    }
  }

  void _showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      // If ad wasn't ready, try to load it for next time
      loadAd();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
