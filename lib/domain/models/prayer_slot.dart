import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/models/prayer_status.dart';
import 'package:flutter/material.dart';

enum PrayerSlot {
  fajr,
  zuhr,
  asr,
  maghrib,
  isha;

  String get label => switch (this) {
        PrayerSlot.fajr => 'Fajr',
        PrayerSlot.zuhr => 'Zuhr',
        PrayerSlot.asr => 'Asr',
        PrayerSlot.maghrib => 'Maghrib',
        PrayerSlot.isha => 'Isha',
      };

  String get hint => switch (this) {
        PrayerSlot.fajr => 'Dawn',
        PrayerSlot.zuhr => 'Noon',
        PrayerSlot.asr => 'Afternoon',
        PrayerSlot.maghrib => 'Sunset',
        PrayerSlot.isha => 'Night',
      };

  IconData get icon => switch (this) {
        PrayerSlot.fajr => Icons.wb_twilight_rounded,
        PrayerSlot.zuhr => Icons.wb_sunny_rounded,
        PrayerSlot.asr => Icons.wb_cloudy_rounded,
        PrayerSlot.maghrib => Icons.wb_twilight_rounded,
        PrayerSlot.isha => Icons.nightlight_rounded,
      };

  TimeOfDay? get sortHint => switch (this) {
        PrayerSlot.fajr => const TimeOfDay(hour: 5, minute: 0),
        PrayerSlot.zuhr => const TimeOfDay(hour: 12, minute: 30),
        PrayerSlot.asr => const TimeOfDay(hour: 15, minute: 45),
        PrayerSlot.maghrib => const TimeOfDay(hour: 18, minute: 30),
        PrayerSlot.isha => const TimeOfDay(hour: 20, minute: 0),
      };
}

extension PrayerSlotMutation on Prayer {
  bool? valueFor(PrayerSlot slot) => switch (slot) {
        PrayerSlot.fajr => fajr,
        PrayerSlot.zuhr => zuhr,
        PrayerSlot.asr => asr,
        PrayerSlot.maghrib => maghrib,
        PrayerSlot.isha => isha,
      };

  void setSlot(PrayerSlot slot, bool? value) {
    switch (slot) {
      case PrayerSlot.fajr:
        fajr = value;
      case PrayerSlot.zuhr:
        zuhr = value;
      case PrayerSlot.asr:
        asr = value;
      case PrayerSlot.maghrib:
        maghrib = value;
      case PrayerSlot.isha:
        isha = value;
    }
  }

  PrayerStatus statusFor(PrayerSlot slot) =>
      prayerStatus(valueFor(slot));

  /// Pending → prayed → missed → pending
  void cycleSlot(PrayerSlot slot) {
    final next = switch (valueFor(slot)) {
      null => true,
      true => false,
      false => null,
    };
    setSlot(slot, next);
  }
}
