import 'package:beseech/navigator/navigator_repository.dart';

import '../main.dart';

final navigatorBloc = NavigatorBloc();

class NavigatorBloc {
  ///
  NavigatorRepository get _navigatorRepository => navigatorRepository;

  ///
  GlobalKey<NavigatorState> get key {
    return _navigatorRepository.navigator.navigatorKey;
  }

  late final to = _navigatorRepository.to;
  late final back = _navigatorRepository.back;
  late final dialog = _navigatorRepository.dialog;
  late final toReplacement = _navigatorRepository.toReplacement;
}
