import 'package:beseech/ui/prayers/prayers_page.dart';
import 'package:beseech/business/splash_repository.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:beseech/utils/navigator.dart';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

// final splashBloc = SplashBloc();

class SplashBloc extends Bloc {
  late final SplashRepository splashRepository = watch();

  late final createTimer = splashRepository.createTimer;
  // late final dispose = splashRepository.dispose;

  bool get initialized => splashRepository.initialized;

  void initialize() {
    // splashRepository.initialize();
    navigator.to(PrayersPage());
  }

  @override
  void initState() {
    super.initState();
    createTimer(1.seconds, () {
      if (initialized) {
        // navigatorBloc.toReplacement(HomePage());
        // navigator.to(HomePage());
      } else {
        navigator.toReplacement(PrayersPage());
      }
    });
  }

  void didUnmountWidget() {
    dispose();
    // super.didUnmountWidget();
  }
}

class SplashPage extends StatelessWidget {
  // @override
  // SplashBloc create() => SplashBloc();
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.mosque, size: 120),
          Text(
            _dua,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

const _dua = 'اللَّهُمَّ افْتَحْ لي أَبْوابَ رَحْمَتِكَ';
