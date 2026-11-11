import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/domain/models/prayer_status.dart';
import 'package:flutter/material.dart';

Color prayerStatusColor(PrayerStatus status, ColorScheme scheme) {
  return switch (status) {
    PrayerStatus.prayed => BeseechColors.ada,
    PrayerStatus.notPrayed => scheme.error,
    PrayerStatus.awaiting => BeseechColors.awaiting,
  };
}

IconData prayerStatusIcon(PrayerStatus status) {
  return switch (status) {
    PrayerStatus.prayed => Icons.check_circle_rounded,
    PrayerStatus.notPrayed => Icons.cancel_rounded,
    PrayerStatus.awaiting => Icons.schedule_rounded,
  };
}

String prayerStatusLabel(PrayerStatus status) {
  return switch (status) {
    PrayerStatus.prayed => 'Ada',
    PrayerStatus.notPrayed => 'Qaza',
    PrayerStatus.awaiting => 'Pending',
  };
}

Color prayerBoolColor(bool? value) {
  return switch (value) {
    true => BeseechColors.ada,
    false => BeseechColors.qaza,
    null => BeseechColors.accentWarm,
  };
}
