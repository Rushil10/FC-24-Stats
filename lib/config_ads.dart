const String appFlavor = String.fromEnvironment('FLAVOR');
const String appYear = String.fromEnvironment('YEAR', defaultValue: '24');
const bool showAds = appFlavor != 'pro';
const String appTitle = 'Player Stats $appYear';
