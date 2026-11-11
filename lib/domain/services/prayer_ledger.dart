import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/models/user.dart';
/// Lifetime prayer balance from obligation start → today.
class PrayerLedger {
  PrayerLedger({
    required this.user,
    required this.prayers,
  });

  final User user;
  final List<Prayer> prayers;

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime get obligationStart => dateOnly(user.prayerObligationStart);

  DateTime get today => dateOnly(DateTime.now());

  int get obligationDays {
    if (today.isBefore(obligationStart)) return 0;
    return today.difference(obligationStart).inDays + 1;
  }

  int get lifetimeSlotsExpected => obligationDays * 5;

  int get lifetimeAda =>
      prayers.fold(0, (sum, p) => sum + p.adaCount);

  int get lifetimeQaza =>
      prayers.fold(0, (sum, p) => sum + p.qazaCount);

  int get lifetimeAwaitingInLogs =>
      prayers.fold(0, (sum, p) => sum + p.awaitingCount);

  Set<DateTime> get _loggedDays =>
      prayers.map((p) => dateOnly(p.date)).toSet();

  int get unloggedDays {
    var count = 0;
    for (var day = obligationStart;
        !day.isAfter(today);
        day = day.add(const Duration(days: 1))) {
      if (!_loggedDays.contains(day)) count++;
    }
    return count;
  }

  int get unloggedPrayerSlots => unloggedDays * 5;

  /// Prayers still owed: missed + pending in logs + never-logged days.
  int get remainingPrayers =>
      lifetimeQaza + lifetimeAwaitingInLogs + unloggedPrayerSlots;

  Prayer? get _todayRecord {
    for (final prayer in prayers) {
      if (dateOnly(prayer.date) == today) return prayer;
    }
    return null;
  }

  int get todayRemaining {
    final record = _todayRecord;
    if (record == null) return 5;
    return record.awaitingCount;
  }

  double get completionRatio {
    if (lifetimeSlotsExpected <= 0) return 0;
    return (lifetimeAda / lifetimeSlotsExpected).clamp(0.0, 1.0);
  }
}
