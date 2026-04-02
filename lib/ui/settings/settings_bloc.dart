import 'package:beseech/business/user_repository.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:beseech/utils/navigator.dart';
import 'package:beseech/business/settings_repository.dart';
import 'package:beseech/ui/splash/splash_page.dart';
import 'package:beseech/business/splash_repository.dart';

class SettingsBloc extends Bloc {
  late SettingsRepository settingsRepository = watch();
  // ignore: unused_element
  SplashRepository get _splashRepository => splashRepository;
  NavigatorRepository get _navigatorRepository => navigator;
  // PrayersRepository get _prayersRepository => prayersRepository;
  UserRepository get _userRepository => userRepository;

  // late var settings = signal(settingsRepository.settings());

  bool get dark => settingsRepository.dark;

  // double get padding => settings().padding;
  // double get borderRadius => settings().borderRadius;
  // ThemeMode get themeMode =>
  // settings().isDark ? ThemeMode.dark : ThemeMode.light;
  // MaterialColor get color => Colors.primaries[settings().colorIndex];

  // void setBorderRadius(double value) {
  //   settingsRepository.setBorderRadius(value);
  // }

  // void setPadding(double value) {
  //   settingsRepository.setPadding(value);
  // }

  // void setThemeMode(ThemeMode? value) {
  //   settingsRepository.setThemeMode(value);
  // }

  // void setColor(MaterialColor value) {
  //   settingsRepository.setColor(value);
  // }

  void restoreApp() {
    // _splashRepository.deInitialize();
    // _prayersRepository.removeAll();
    _userRepository.resetUser();
    _navigatorRepository.toAndRemoveUntil(SplashPage());
  }
}
