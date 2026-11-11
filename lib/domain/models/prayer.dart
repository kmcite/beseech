import 'package:beseech/domain/models/prayer_status.dart';
import 'package:shared_database/shared_database.dart';

class Prayer {
  Prayer({
    this.id,
    DateTime? date,
    this.fajr,
    this.zuhr,
    this.asr,
    this.maghrib,
    this.isha,
  }) : date = date ?? DateTime.now();

  String? id;
  DateTime date;

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

  factory Prayer.fromRecord(SharedRecord record) {
    final data = record.data;
    return Prayer(
      id: record.id,
      date: DateTime.parse(data['date'] as String),
      fajr: data['fajr'] as bool?,
      zuhr: data['zuhr'] as bool?,
      asr: data['asr'] as bool?,
      maghrib: data['maghrib'] as bool?,
      isha: data['isha'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': DateTime(date.year, date.month, date.day).toIso8601String(),
        'fajr': fajr,
        'zuhr': zuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  int get awaitingCount {
    var count = 0;
    if (fajr == null) count++;
    if (zuhr == null) count++;
    if (asr == null) count++;
    if (maghrib == null) count++;
    if (isha == null) count++;
    return count;
  }

  int get adaCount {
    var count = 0;
    if (fajr == true) count++;
    if (zuhr == true) count++;
    if (asr == true) count++;
    if (maghrib == true) count++;
    if (isha == true) count++;
    return count;
  }

  int get qazaCount {
    var count = 0;
    if (fajr == false) count++;
    if (zuhr == false) count++;
    if (asr == false) count++;
    if (maghrib == false) count++;
    if (isha == false) count++;
    return count;
  }

  @override
  String toString() =>
      'Prayer{id: $id, date: $date, fajr: $fajr, zuhr: $zuhr, asr: $asr, maghrib: $maghrib, isha: $isha}';
}
