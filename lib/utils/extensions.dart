import 'package:beseech/business/business.dart';
import 'package:flutter/material.dart';
import 'package:fountain/fountain.dart';

extension BoolLogic on bool {
  bool and(bool other) => this && other;
  bool or(bool other) => this || other;
  bool not() => !this;

  T choose<T>(T whenTrue, T whenFalse) => this ? whenTrue : whenFalse;
}

extension ON on BuildContext {
  Business get state => select((Business state) => state);
  void apply(Event event) {
    dispatch<Business>(event);
  }

  T on<T>(T Function(Business state) state) {
    return select<Business, T>(state);
  }
}
