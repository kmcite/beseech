import 'package:beseech/main.dart';

import 'package:beseech/navigator/navigator_bloc.dart';
import 'package:beseech/splash/splash_bloc.dart';

class SplashPage extends UI {
  @override
  void didMountWidget(BuildContext context) {
    super.didMountWidget(context);

    splashBloc.createTimer(
      1.seconds,
      () {
        // if (splashBloc.initialized) {
        //   // navigatorBloc.toReplacement(HomePage());
        // } else {}
        navigatorBloc.toReplacement(PrayersPage());
      },
    );
  }

  @override
  void didUnmountWidget() {
    splashBloc.dispose();
    super.didUnmountWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mosque,
            size: 120,
          ),
          _dua.text(textScaleFactor: 2).center().pad(),
        ],
      ),
    );
  }
}

const _dua = 'اللَّهُمَّ افْتَحْ لي أَبْوابَ رَحْمَتِكَ';
