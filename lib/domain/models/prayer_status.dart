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
