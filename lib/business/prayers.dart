import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/models/prayer_slot.dart';
import 'package:beseech/domain/models/user.dart';
import 'package:beseech/domain/repositories/prayers_repository.dart';
import 'package:beseech/domain/services/prayer_ledger.dart';
import 'package:flutter/foundation.dart';

class PrayersController extends ChangeNotifier {
  PrayersController(this._repository) {
    _repository.addListener(notifyListeners);
  }

  final PrayersRepository _repository;

  List<Prayer> get prayers => _repository.prayers;

  List<Prayer> get records {
    final list = List<Prayer>.from(prayers);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  PrayerLedger ledger(User user) => PrayerLedger(user: user, prayers: prayers);

  Prayer? prayerOn(DateTime date) =>
      _repository.byDate(PrayersRepository.dateOnly(date));

  Future<Prayer> ensureDay(DateTime date) async {
    final day = PrayersRepository.dateOnly(date);
    final existing = _repository.byDate(day);
    if (existing != null) return existing;
    final created = Prayer(date: day);
    await _repository.put(created);
    return created;
  }

  Future<void> cycleSlot(DateTime date, PrayerSlot slot) async {
    final prayer = await ensureDay(date);
    prayer.cycleSlot(slot);
    await _repository.put(prayer);
  }

  Future<void> setSlot(DateTime date, PrayerSlot slot, bool? value) async {
    final prayer = await ensureDay(date);
    prayer.setSlot(slot, value);
    await _repository.put(prayer);
  }

  Future<void> deleteDay(Prayer prayer) => _repository.remove(prayer);

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }
}
