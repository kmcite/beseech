import 'package:beseech/user/user_repository.dart';

final UserBloc userBloc = UserBloc();

class UserBloc {
  UserRepository get _userRepository => userRepository;

  String get userName => _userRepository.user.name;

  void setUserName(String value) {
    _userRepository.setName(value);
  }

  AgeVysor get ageVysor => _userRepository.user.ageVysor;

  DateTime get dateOfBirth => _userRepository.user.dateOfBirth;
  DateTime get dateOfPuberty => _userRepository.user.dateOfPuberty;

  Duration get age => _userRepository.age;
  bool get editing => _userRepository.editing;

  bool get knowsPubertyDate => _userRepository.knowsPubertyDate;

  void setDateOfBirth(DateTime value) {
    _userRepository.setDateOfBirth(value);
  }

  // void setDateOfPuberty(DateTime value) {
  //   _userRepository.setDateOfPuberty(value);
  // }

  void setAgeVysor(AgeVysor? value) {
    _userRepository.setAgeVysor(value!);
  }

  void setEditing(bool value) {
    _userRepository.setEditing(value);
  }

  void setKnowsPubertyDate(bool value) {
    _userRepository.setKnowsPubertyDate(value);
  }
}
