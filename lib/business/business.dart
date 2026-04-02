import 'package:beseech/domain/models/prayer.dart';
import 'package:fountain/fountain.dart';

class Business {
  bool dark = false;
  List<Prayer> prayers = const [];
  DateTime selectedDate = DateTime.now();
}

class ChangeSelectedDate extends Action<Business> {
  final DateTime date;
  ChangeSelectedDate(this.date);

  @override
  Stream<Updater<Business>> call(context) async* {
    yield (state) => state..selectedDate = date;
  }
}
