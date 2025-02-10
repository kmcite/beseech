import 'package:beseech/main.dart';

final navigatorRepository = NavigatorRepository();

class NavigatorRepository {
  final navigator = RM.navigate;
  late final to = navigator.to;
  late final toReplacement = navigator.toReplacement;
  late final toAndRemoveUntil = navigator.toAndRemoveUntil;
  late final back = navigator.back;
  late final dialog = navigator.toDialog;
}




////
/// 