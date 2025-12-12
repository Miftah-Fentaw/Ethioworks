import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

enum AppPlatform { mobile, webAndDesktop }

class PlatformChecker {
  static AppPlatform detectPlatform() {
    if (kIsWeb) return AppPlatform.webAndDesktop;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return AppPlatform.mobile;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return AppPlatform.webAndDesktop;
      default:
        return AppPlatform.mobile;
    }
  }
}
