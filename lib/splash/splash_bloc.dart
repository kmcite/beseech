import 'package:beseech/main.dart';
import 'package:beseech/navigator/navigator_repository.dart';
import 'package:beseech/splash/splash_repository.dart';

final splashBloc = SplashBloc();

class SplashBloc {
  /// DEPENDENCIES
  SplashRepository get _splashRepository => splashRepository;
  NavigatorRepository get _navigatorRepository => navigatorRepository;

  late final createTimer = _splashRepository.createTimer;
  late final dispose = _splashRepository.dispose;

  bool get initialized => splashRepository.initialized;

  void initialize() {
    _splashRepository.initialize();
    _navigatorRepository.to(PrayersPage());
  }
}
