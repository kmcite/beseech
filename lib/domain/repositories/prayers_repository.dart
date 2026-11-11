import 'dart:async';

import 'package:beseech/domain/collections.dart';
import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_database/shared_database.dart';

class PrayersRepository extends ChangeNotifier {
  PrayersRepository(this._database);

  final DatabaseService _database;
  StreamSubscription<List<SharedRecord>>? _watch;
  List<Prayer> _prayers = [];

  List<Prayer> get prayers => List.unmodifiable(_prayers);

  Future<void> init() async {
    await _database.db.getAll(BeseechCollections.prayers);
    _watch = _database.db
        .watchCollection(BeseechCollections.prayers)
        .listen(_onCollectionChanged);
  }

  void _onCollectionChanged(List<SharedRecord> records) {
    _prayers = records
        .map(Prayer.fromRecord)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool dateOnlyComparison(DateTime one, DateTime other) {
    return one.year == other.year &&
        one.month == other.month &&
        one.day == other.day;
  }

  Prayer? byDate(DateTime dateOnly) {
    for (final prayer in _prayers) {
      if (dateOnlyComparison(prayer.date, dateOnly)) return prayer;
    }
    return null;
  }

  bool existsByDate(DateTime dateOnly) => byDate(dateOnly) != null;

  Future<void> put(Prayer prayer) async {
    final id = await _database.db.put(
      BeseechCollections.prayers,
      prayer.toJson(),
      id: prayer.id,
    );
    prayer.id ??= id;
    if (kDebugMode) {
      // ignore: avoid_print
      print('put<Prayer> id=$id');
    }
  }

  Future<void> remove(Prayer prayer) async {
    final id = prayer.id;
    if (id == null) return;
    await _database.db.delete(BeseechCollections.prayers, id);
  }

  Future<void> removeAll() async {
    for (final prayer in List<Prayer>.from(_prayers)) {
      await remove(prayer);
    }
  }

  @override
  void dispose() {
    _watch?.cancel();
    super.dispose();
  }
}
