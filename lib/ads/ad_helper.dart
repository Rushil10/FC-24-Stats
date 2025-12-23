import 'dart:io';

//ca-app-pub-3940256099942544/6300978111
//ca-app-pub-7992896789862342/8571606115
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7992896789862342/1992435025";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7992896789862342/4861276027";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get videoAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7992896789862342/9679353352";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7992896789862342/8992447943";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7992896789862342/4967697127";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7992896789862342/4123264649";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
