import 'package:beseech/business/prayers_repository.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Prayer {
  @Id(assignable: true)
  int id = 0;
  DateTime date = DateTime.now();

  /// initialized with null -> awaiting
  bool? fajr;
  bool? zuhr;
  bool? asr;
  bool? maghrib;
  bool? isha;

  PrayerStatus get fajrStatus => prayerStatus(fajr);
  set fajrStatus(PrayerStatus status) => fajr = statusPrayer(status);
  PrayerStatus get zuhrStatus => prayerStatus(zuhr);
  set zuhrStatus(PrayerStatus status) => zuhr = statusPrayer(status);
  PrayerStatus get asrStatus => prayerStatus(asr);
  set asrStatus(PrayerStatus status) => asr = statusPrayer(status);
  PrayerStatus get maghribStatus => prayerStatus(maghrib);
  set maghribStatus(PrayerStatus status) => maghrib = statusPrayer(status);
  PrayerStatus get ishaStatus => prayerStatus(isha);
  set ishaStatus(PrayerStatus status) => isha = statusPrayer(status);

  @override
  String toString() {
    return 'Prayer{id: $id, date: $date, fajr: $fajr, zuhr: $zuhr, asr: $asr, maghrib: $maghrib, isha: $isha';
  }

  int get awaitingCount {
    int count = 0;
    if (fajr == null) count++;
    if (zuhr == null) count++;
    if (asr == null) count++;
    if (maghrib == null) count++;
    if (isha == null) count++;
    return count;
  }

  int get adaCount {
    int count = 0;
    if (fajr == true) count++;
    if (zuhr == true) count++;
    if (asr == true) count++;
    if (maghrib == true) count++;
    if (isha == true) count++;
    return count;
  }

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
