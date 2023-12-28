import 'package:flutter/services.dart';
import 'package:fc_stats_24/screens/SetUpLocalDb.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifa 24 Stats',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeClass.darkTheme,
      theme: ThemeClass.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SetUpLocalDb(),
    );
  }
}
