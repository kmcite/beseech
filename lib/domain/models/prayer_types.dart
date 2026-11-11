import 'package:flutter/material.dart' show IconData, ThemeMode, Icons;

enum PrayerTypes { fajr, zuhr, asr, maghrib, isha, eid, jumma }

extension IconDataExtensionOnThemeMode on ThemeMode {
  IconData get icon {
    return switch (this) {
      ThemeMode.system => Icons.settings,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }
}
