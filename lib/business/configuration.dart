import 'package:beseech/domain/models/settings.dart';
import 'package:beseech/domain/repositories/configuration_repository.dart';
import 'package:beseech/domain/repositories/prayers_repository.dart';
import 'package:beseech/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class ConfigurationController extends ChangeNotifier {
  ConfigurationController(
    this._prayersRepository,
    this._userRepository,
    this._configurationRepository,
  ) {
    _dark = _configurationRepository.settings.isDark;
    _configurationRepository.addListener(_onSettingsChanged);
  }

  final PrayersRepository _prayersRepository;
  final UserRepository _userRepository;
  final ConfigurationRepository _configurationRepository;

  DateTime _selectedDate = DateTime.now();
  late bool _dark;

  bool get isReady => _configurationRepository.isReady;
  bool get dark => _dark;
  DateTime get selectedDate => _selectedDate;

  void _onSettingsChanged() {
    final next = _configurationRepository.settings.isDark;
    if (next != _dark) {
      _dark = next;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime value) {
    _selectedDate = DateTime(value.year, value.month, value.day);
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _dark = value;
    notifyListeners();
    final next = Settings.fromJson(_configurationRepository.settings.toJson())
      ..isDark = value;
    await _configurationRepository.save(next);
  }

  void toggleDark() => setDark(!_dark);

  Future<void> restoreApplication() async {
    await _prayersRepository.removeAll();
    await _userRepository.reset();
  }

  @override
  void dispose() {
    _configurationRepository.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
