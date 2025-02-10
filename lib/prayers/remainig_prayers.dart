import 'package:beseech/main.dart';
import 'package:beseech/prayers/prayers_bloc.dart';

class RemainingPrayers extends UI {
  const RemainingPrayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        'Incomplete'.text(textScaleFactor: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prayersBloc.qazaPrayersCount.text(textScaleFactor: 2.6),
            Icon(
              Icons.cancel,
              color: Colors.red,
            ).pad(),
          ],
        ),
        'Completed'.text(textScaleFactor: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prayersBloc.adaPrayersCount.text(textScaleFactor: 2.6),
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ).pad(),
          ],
        ),
      ],
    ).pad();
  }
}
