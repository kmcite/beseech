import 'package:flutter/material.dart';
import 'package:navigation_builder/navigation_builder.dart';

final navigator = NavigatorRepository();

class NavigatorRepository {
  final navigator = NavigationBuilder.navigate;
  GlobalKey<NavigatorState> get navigatorKey => navigator.navigatorKey;

  late final to = navigator.to;
  late final toReplacement = navigator.toReplacement;
  late final toAndRemoveUntil = navigator.toAndRemoveUntil;
  late final back = navigator.back;
  late final dialog = navigator.toDialog;
}

extension TextX on dynamic {
  Text text() => Text(toString());
}

extension IntX on int {
  /// Duration on seconds
  Duration get seconds => Duration(seconds: this);

  /// Duration on milliseconds
  Duration get milliseconds => Duration(milliseconds: this);

  /// Duration on minutes
  Duration get minutes => Duration(minutes: this);

  /// Duration on hours
  Duration get hours => Duration(hours: this);
}
