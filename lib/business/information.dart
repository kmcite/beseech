import 'dart:async';

import 'package:beseech/domain/models/age_vysor.dart';
import 'package:beseech/domain/models/user.dart';
import 'package:beseech/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class InformationController extends ChangeNotifier {
  InformationController(this._userRepository) {
    _userRepository.addListener(notifyListeners);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => notifyListeners());
  }

  final UserRepository _userRepository;
  late final Timer _ticker;

  User get user => _userRepository.user;

  Duration get age => user.age;

  Future<void> setName(String value) => _userRepository.save(user..name = value);

  Future<void> setDateOfBirth(DateTime value) =>
      _userRepository.save(user..dateOfBirth = value);

  Future<void> setDateOfPuberty(DateTime value) =>
      _userRepository.save(user..dateOfPuberty = value);

  Future<void> setKnowsPubertyDate(bool value) =>
      _userRepository.save(user..knowsPubertyDate = value);

  Future<void> setAgeVysor(AgeVysor value) =>
      _userRepository.save(user..ageVysor = value);

  @override
  void dispose() {
    _ticker.cancel();
    _userRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
