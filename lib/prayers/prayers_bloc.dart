import 'package:beseech/user/user_repository.dart';
import 'package:beseech/prayers/prayers_repository.dart';

final PrayersBloc prayersBloc = PrayersBloc();

class PrayersBloc {
  static const fourteenYears = Duration(days: 365 * 14);

  UserRepository get _userRepository => userRepository;
  PrayersRepository get _prayersRepository => prayersRepository;

  List<Prayer> get prayers => _prayersRepository.getAll();
  void put(Prayer prayer) {
    prayersRepository.put(prayer);
  }

  @deprecated
  void createEntriesForPrayers() {}

  int get qazaPrayersCount => prayers.fold(
        0,
        (old, prayer) => old + prayer.qazaCount,
      );
  int get adaPrayersCount => prayers.fold(
        0,
        (old, prayer) => old + prayer.adaCount,
      );

  int get awaitingPrayersCount => prayers.fold(
        0,
        (value, prayer) => value + prayer.awaitingCount,
      );

  void remove(Prayer prayer) {
    _prayersRepository.remove(prayer.id);
  }
}
