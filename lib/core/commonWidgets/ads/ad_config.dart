import 'package:flutter/foundation.dart';

/// Single source of truth for all AdMob unit IDs.
/// Debug builds → Google's official test IDs (safe, never flagged).
/// Release builds → your real IDs.
class AdConfig {
  AdConfig._();

  static String get banner => kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'   // test
      : 'ca-app-pub-3807575016898926/6218530770';  // real

  static String get interstitial => kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'   // test
      : 'ca-app-pub-3807575016898926/1867051366';  // real

  static String get rewarded => kDebugMode
      ? 'ca-app-pub-3940256099942544/5224354917'   // test
      : 'ca-app-pub-3807575016898926/6684263770';  // real
}
