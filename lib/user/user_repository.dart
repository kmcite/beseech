import 'package:beseech/main.dart';

import 'user_bloc.dart';

class UserRepository {
  Duration get age => user.age;

  late final userRM = RM.injectStream<User>(
    () => Stream.periodic(
      1.seconds,
      (_) {
        setUser(user..tracking = _);
        return user;
      },
    ),
    initialState: User(),
    persist: () => persisted(
      'user',
      User.fromJson,
    ),
  );

  User get user => userRM.state;
  bool get editing => user.editing;

  void setUser(User user) {
    userRM
      ..state = user
      ..notify();
  }

  void setName(String name) {
    setUser(user..name = name);
  }

  void setDateOfBirth(DateTime dateOfBirth) {
    setUser(user..dateOfBirth = dateOfBirth);
  }

  // void setDateOfPuberty(DateTime dateOfPuberty) {
  //   setUser(user.._dateOfPuberty = dateOfPuberty);
  // }

  void setAgeVysor(AgeVysor ageVysor) {
    setUser(user..ageVysor = ageVysor);
  }

  void setEditing(bool value) {
    setUser(user..editing = value);
  }

  bool get knowsPubertyDate => user.knowsPubertyDate;

  void setKnowsPubertyDate(bool value) {
    setUser(user..knowsPubertyDate = value);
  }

  void resetUser() {
    setUser(User());
  }
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
          json['dateOfBirth'] ?? DateTime(1995).toIso8601String())
      .._dateOfPuberty = DateTime.parse(
          json['_dateOfPuberty'] ?? DateTime(2005).toIso8601String())
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

  Widget get ui {
    return switch (this) {
      AgeVysor.years => "${userBloc.age.inDays ~/ (30 * 12)} YEARS".text(),
      AgeVysor.months => "${userBloc.age.inDays ~/ 30} MONTHS".text(),
      AgeVysor.days => "${userBloc.age.inDays} DAYS".text(),
      AgeVysor.hours => "${userBloc.age.inHours} HOURS".text(),
      AgeVysor.minutes => "${userBloc.age.inMinutes} MINUTES".text(),
      AgeVysor.seconds => "${userBloc.age.inSeconds} SECONDS".text(),
    };
  }
}
