import 'package:beseech/utils/navigator.dart';
import 'package:flutter/material.dart';

import '../../utils/architecture.dart';

class UserRepository extends Repository {
  User user = User();

  void setUser(User value) {
    user = value;
    // notifyListeners();
  }

  Duration get age => user.age;

  // late final userRM = RM.injectStream<User>(
  //   () => Stream.periodic(
  //     1.seconds,
  //     (tracking) {
  //       user(user()..tracking = tracking);
  //       return user();
  //     },
  //   ),
  //   initialState: User(),
  //   // persist: () => persisted(
  //   //   'user',
  //   //   User.fromJson,
  //   // ),
  // );
  // User user([User? value]) {
  //   if (value != null) {
  //     userRM
  //       ..state = value
  //       ..notify();
  //   }
  //   return userRM.state;
  // }

  String name([String? name]) {
    if (name != null) {
      setUser(user..name = name);
    }
    return user.name;
  }

  DateTime dateOfBirth([DateTime? dateOfBirth]) {
    if (dateOfBirth != null) {
      setUser(user..dateOfBirth = dateOfBirth);
    }
    return user.dateOfBirth;
  }

  DateTime dateOfPuberty([DateTime? dateOfPuberty]) {
    if (dateOfPuberty != null) {
      setUser(user.._dateOfPuberty = dateOfPuberty);
    }
    return user.dateOfPuberty;
  }

  AgeVysor ageVysor([AgeVysor? ageVysor]) {
    if (ageVysor != null) {
      setUser(user..ageVysor = ageVysor);
    }
    return user.ageVysor;
  }

  bool editing([bool? editing]) {
    if (editing != null) {
      setUser(user..editing = editing);
    }
    return user.editing;
  }

  bool knowsPubertyDate([bool? knowsPubertyDate]) {
    if (knowsPubertyDate != null) {
      setUser(user..knowsPubertyDate = knowsPubertyDate);
    }
    return user.knowsPubertyDate;
  }

  void resetUser() => setUser(User());
}

final userRepository = UserRepository();

class User {
  User();
  bool knowsPubertyDate = false;
  bool editing = false;
  String name = '';
  DateTime dateOfBirth = DateTime(1995);
  DateTime _dateOfPuberty = DateTime(2005);
  DateTime get dateOfPuberty {
    if (knowsPubertyDate) {
      _dateOfPuberty;
    }
    return dateOfBirth
        // .add(Duration(days: 13 * 365))
        ;
  }

  AgeVysor ageVysor = AgeVysor.seconds;
  Duration get age => dateOfBirth.difference(DateTime.now());
  int tracking = 0;
  Map<String, dynamic> toJson() {
    return {
      'knowsPubertyDate': knowsPubertyDate,
      'editing': editing,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      '_dateOfPuberty': _dateOfPuberty.toIso8601String(),
      'ageVysor': ageVysor.toString().split('.').last,
      'tracking': tracking,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User()
      ..knowsPubertyDate = json['knowsPubertyDate'] ?? false
      ..editing = json['editing'] ?? false
      ..name = json['name'] ?? ''
      ..dateOfBirth = DateTime.parse(
        json['dateOfBirth'] ?? DateTime(1995).toIso8601String(),
      )
      .._dateOfPuberty = DateTime.parse(
        json['_dateOfPuberty'] ?? DateTime(2005).toIso8601String(),
      )
      ..ageVysor = AgeVysor.values.firstWhere(
        (e) => e.toString().split('.').last == json['ageVysor'],
        orElse: () => AgeVysor.seconds,
      )
      ..tracking = json['tracking'] ?? 0;
  }
}

enum AgeVysor {
  years,
  months,
  days,
  hours,
  minutes,
  seconds;

  Widget ui(Duration age) {
    return switch (this) {
      AgeVysor.years => "${age.inDays ~/ (30 * 12)} YEARS".text(),
      AgeVysor.months => "${age.inDays ~/ 30} MONTHS".text(),
      AgeVysor.days => "${age.inDays} DAYS".text(),
      AgeVysor.hours => "${age.inHours} HOURS".text(),
      AgeVysor.minutes => "${age.inMinutes} MINUTES".text(),
      AgeVysor.seconds => "${age.inSeconds} SECONDS".text(),
    };
  }
}
