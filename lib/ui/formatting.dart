import 'package:intl/intl.dart';

extension HumanReadable on DateTime {
  String get humanReadable => DateFormat('dd-MM-yyyy (EEEE)').format(this);
}
