import 'package:beseech/domain/models/age_vysor.dart';

class User {
  User();

  bool knowsPubertyDate = false;
  String name = '';
  DateTime dateOfBirth = DateTime(2000, 1, 1);
  DateTime _dateOfPuberty = DateTime(2013, 1, 1);
  AgeVysor ageVysor = AgeVysor.years;

  DateTime get dateOfPuberty =>
      knowsPubertyDate ? _dateOfPuberty : _estimatedPuberty;

  set dateOfPuberty(DateTime value) => _dateOfPuberty = value;

  DateTime get _estimatedPuberty =>
      DateTime(dateOfBirth.year + 13, dateOfBirth.month, dateOfBirth.day);

  /// First day five daily prayers are counted (puberty or estimate).
  DateTime get prayerObligationStart => dateOfPuberty;

  Duration get age => DateTime.now().difference(dateOfBirth);

  Map<String, dynamic> toJson() => {
        'knowsPubertyDate': knowsPubertyDate,
        'name': name,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'dateOfPuberty': _dateOfPuberty.toIso8601String(),
        'ageVysor': ageVysor.name,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User()
      ..knowsPubertyDate = json['knowsPubertyDate'] as bool? ?? false
      ..name = json['name'] as String? ?? ''
      ..dateOfBirth = DateTime.parse(
        json['dateOfBirth'] as String? ?? '2000-01-01',
      )
      .._dateOfPuberty = DateTime.parse(
        json['dateOfPuberty'] as String? ??
            json['_dateOfPuberty'] as String? ??
            '2013-01-01',
      )
      ..ageVysor = AgeVysor.values.firstWhere(
        (e) => e.name == json['ageVysor'],
        orElse: () => AgeVysor.years,
      );
  }
}
