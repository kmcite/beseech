import '../main.dart';

final prayersRepository = PrayersRepository();

class PrayersRepository {
  final _prayers = store.box<Prayer>();
  late final get = _prayers.get;
  late final getAsync = _prayers.getAsync;
  late final getAll = _prayers.getAll;
  late final getAllAsync = _prayers.getAllAsync;
  late final removeAll = _prayers.removeAll;
  late final remove = _prayers.remove;
  late final put = _prayers.put;
}

@Entity()
class Prayer {
  @Id(assignable: true)
  int id = 0;
  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  /// initialized with null -> awaiting
  bool? fajr;
  bool? zuhr;
  bool? asr;
  bool? maghrib;
  bool? isha;

  @Transient()
  PrayerStatus get fajrStatus => prayerStatus(fajr);
  set fajrStatus(PrayerStatus status) => fajr = statusPrayer(status);
  @Transient()
  PrayerStatus get zuhrStatus => prayerStatus(zuhr);
  set zuhrStatus(PrayerStatus status) => zuhr = statusPrayer(status);
  @Transient()
  PrayerStatus get asrStatus => prayerStatus(asr);
  set asrStatus(PrayerStatus status) => asr = statusPrayer(status);
  @Transient()
  PrayerStatus get maghribStatus => prayerStatus(maghrib);
  set maghribStatus(PrayerStatus status) => maghrib = statusPrayer(status);
  @Transient()
  PrayerStatus get ishaStatus => prayerStatus(isha);
  set ishaStatus(PrayerStatus status) => isha = statusPrayer(status);

  @override
  String toString() {
    return 'Prayer{id: $id, date: $date, fajr: $fajr, zuhr: $zuhr, asr: $asr, maghrib: $maghrib, isha: $isha';
  }

  @Transient()
  int get awaitingCount {
    int count = 0;
    if (fajr == null) count++;
    if (zuhr == null) count++;
    if (asr == null) count++;
    if (maghrib == null) count++;
    if (isha == null) count++;
    return count;
  }

  @Transient()
  int get adaCount {
    int count = 0;
    if (fajr == true) count++;
    if (zuhr == true) count++;
    if (asr == true) count++;
    if (maghrib == true) count++;
    if (isha == true) count++;
    return count;
  }

  @Transient()
  int get qazaCount {
    int count = 0;
    if (fajr == false) count++;
    if (zuhr == false) count++;
    if (asr == false) count++;
    if (maghrib == false) count++;
    if (isha == false) count++;
    return count;
  }
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
