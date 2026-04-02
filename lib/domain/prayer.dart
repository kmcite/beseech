// prayers_objectbox_repo.dart
// ObjectBox-based repository + entities (offline-first)

import 'dart:async';
import 'package:beseech/objectbox.g.dart' show DailyPrayerSheetEntity_;
import 'package:objectbox/objectbox.dart';

/// ---------- Enums ----------

enum PrayerType {
  fajr,
  zuhr,
  asr,
  maghrib,
  isha,
  jumma,
  eidFitr,
  eidAdha,
}

/// ---------- ObjectBox Entities ----------

@Entity()
class PrayerEntryEntity {
  @Id()
  int id = 0;

  DateTime date; // normalized date
  String type; // PrayerType.name
  bool prayed;
  DateTime? markedAt;
  final dailyPrayer = ToOne<DailyPrayerSheetEntity>();

  PrayerEntryEntity({
    DateTime? date,
    this.type = 'fajr',
    this.prayed = false,
    this.markedAt,
  }) : date = _normalize(date ?? DateTime.now());

  void markPrayed() {
    prayed = true;
    markedAt = DateTime.now();
  }

  void unmark() {
    prayed = false;
    markedAt = null;
  }

  PrayerType get prayerType =>
      PrayerType.values.firstWhere((e) => e.name == type);

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);
}

@Entity()
class DailyPrayerSheetEntity {
  @Id()
  int id;

  @Unique()
  DateTime date;

  @Backlink()
  final prayers = ToMany<PrayerEntryEntity>();

  DailyPrayerSheetEntity({
    this.id = 0,
    DateTime? date,
  }) : date = _normalize(date ?? DateTime.now());

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);
}

/// ---------- Repository Contract ----------

abstract class PrayerRepository {
  Stream<List<DailyPrayerSheetEntity>> watchAll();
  Future<DailyPrayerSheetEntity> getOrCreateDay(DateTime date);

  Future<void> markPrayer({
    required DateTime date,
    required PrayerType type,
    bool prayed = true,
  });

  Future<void> addEidPrayer({
    required DateTime date,
    required PrayerType type,
  });

  Future<void> clearDay(DateTime date);
}

/// ---------- ObjectBox Implementation ----------

class ObjectBoxPrayerRepository implements PrayerRepository {
  final Store store;
  late final Box<DailyPrayerSheetEntity> _dayBox;
  late final Box<PrayerEntryEntity> _prayerBox;

  final _controller =
      StreamController<List<DailyPrayerSheetEntity>>.broadcast();

  ObjectBoxPrayerRepository(this.store) {
    _dayBox = Box<DailyPrayerSheetEntity>(store);
    _prayerBox = Box<PrayerEntryEntity>(store);
    _emit();
  }

  @override
  Stream<List<DailyPrayerSheetEntity>> watchAll() => _controller.stream;

  void _emit() {
    final days = _dayBox.getAll()..sort((a, b) => a.date.compareTo(b.date));
    _controller.add(days);
  }

  DateTime _key(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isFriday(DateTime d) => d.weekday == DateTime.friday;

  List<PrayerType> _basePrayers(DateTime d) {
    return [
      PrayerType.fajr,
      _isFriday(d) ? PrayerType.jumma : PrayerType.zuhr,
      PrayerType.asr,
      PrayerType.maghrib,
      PrayerType.isha,
    ];
  }

  @override
  Future<DailyPrayerSheetEntity> getOrCreateDay(
    DateTime date,
  ) async {
    final key = _key(date);

    final existing = _dayBox
        .query(DailyPrayerSheetEntity_.date.equals(key.millisecondsSinceEpoch))
        .build()
        .findFirst();

    if (existing != null) return existing;

    final day = DailyPrayerSheetEntity(date: key);
    _dayBox.put(day);

    for (final p in _basePrayers(key)) {
      final entry = PrayerEntryEntity(
        date: key,
        type: p.name,
      );
      entry
        ..id = _prayerBox.put(entry)
        ..also(() => day.prayers.add(entry));
    }

    _dayBox.put(day);
    _emit();
    return day;
  }

  @override
  Future<void> markPrayer({
    required DateTime date,
    required PrayerType type,
    bool prayed = true,
  }) async {
    final day = await getOrCreateDay(date);

    final entry = day.prayers.firstWhere(
      (p) => p.type == type.name,
      orElse: () {
        final e = PrayerEntryEntity(
          date: day.date,
          type: type.name,
        );
        _prayerBox.put(e);
        day.prayers.add(e);
        return e;
      },
    );

    prayed ? entry.markPrayed() : entry.unmark();
    _prayerBox.put(entry);
    _emit();
  }

  @override
  Future<void> addEidPrayer({
    required DateTime date,
    required PrayerType type,
  }) async {
    assert(
      type == PrayerType.eidFitr || type == PrayerType.eidAdha,
    );

    final day = await getOrCreateDay(date);

    final entry = PrayerEntryEntity(
      date: day.date,
      type: type.name,
    );

    _prayerBox.put(entry);
    day.prayers.add(entry);
    _dayBox.put(day);
    _emit();
  }

  @override
  Future<void> clearDay(DateTime date) async {
    final key = _key(date);

    final day = _dayBox
        .query(DailyPrayerSheetEntity_.date.equals(key.millisecondsSinceEpoch))
        .build()
        .findFirst();

    if (day == null) return;

    for (final p in day.prayers) {
      _prayerBox.remove(p.id);
    }
    _dayBox.remove(day.id);
    _emit();
  }
}

/// ---------- Small helper ----------
extension _Cascade<T> on T {
  T also(void Function() fn) {
    fn();
    return this;
  }
}
