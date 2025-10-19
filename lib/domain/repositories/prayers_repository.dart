import 'dart:developer';

import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:objectbox/objectbox.dart';

class PrayersRepository extends Repository {
  final _store = find<Store>();
  Box<Prayer> get box => _store.box();

  void put(Prayer prayer) {
    box.put(prayer);
    if (logging) log('put<Prayer>(), $runtimeType');
    notify('put<Prayer>');
  }

  static bool dateOnlyComparison(DateTime one, DateTime other) {
    return one.year == other.year &&
        one.month == other.month &&
        one.day == other.day;
  }

  Prayer? byDate(DateTime dateOnly) {
    return null;

    // return itemsRM.state.where(
    //   (pry) {
    //     return dateOnlyComparison(pry.date, dateOnly);
    //   },
    // ).firstOrNull;
  }

  bool existsByDate(DateTime dateOnly) => byDate(dateOnly) != null;
}

enum PrayerStatus {
  prayed,
  notPrayed, // qaza
  awaiting,
}

PrayerStatus prayerStatus(bool? value) {
  if (value == null) {
    return PrayerStatus.awaiting;
  }
  return value ? PrayerStatus.prayed : PrayerStatus.notPrayed;
}

bool? statusPrayer(PrayerStatus value) {
  return switch (value) {
    PrayerStatus.prayed => true,
    PrayerStatus.notPrayed => false,
    PrayerStatus.awaiting => null,
  };
}
