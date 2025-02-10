import 'package:beseech/user/user_repository.dart';
import 'package:beseech/main.dart';
import 'package:beseech/navigator/navigator_repository.dart';
import 'package:beseech/prayers/prayers_repository.dart';
import 'package:beseech/settings/settings_repository.dart';
import 'package:beseech/splash/splash_page.dart';
import 'package:beseech/splash/splash_repository.dart';

final settingsBloc = SettingsBloc();

class SettingsBloc {
  SplashRepository get _splashRepository => splashRepository;
  SettingsRepository get _settingsRepository => settingsRepository;
  NavigatorRepository get _navigatorRepository => navigatorRepository;
  PrayersRepository get _prayersRepository => prayersRepository;
  UserRepository get _userRepository => userRepository;

  double get padding => _settingsRepository.padding;
  double get borderRadius => _settingsRepository.borderRadius;
  ThemeMode get themeMode => _settingsRepository.themeMode;
  MaterialColor get color => _settingsRepository.color;

  void setBorderRadius(double value) {
    _settingsRepository.setBorderRadius(value);
  }

  void setPadding(double value) {
    _settingsRepository.setPadding(value);
  }

  void setThemeMode(ThemeMode? value) {
    _settingsRepository.setThemeMode(value);
  }

  void setColor(MaterialColor value) {
    _settingsRepository.setColor(value);
  }

  void restoreApp() {
    _splashRepository.deInitialize();
    _prayersRepository.removeAll();
    _userRepository.resetUser();
    _navigatorRepository.toAndRemoveUntil(SplashPage());
  }
}
