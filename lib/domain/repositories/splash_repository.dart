import 'dart:async';

import 'package:beseech/utils/architecture.dart';

final splashRepository = SplashRepository();

class SplashRepository extends Repository {
  /// Timer for navigation from Splash -> Home / Initial
  Timer? timer;
  void createTimer(
    Duration seconds,
    void Function() onCompleted,
  ) {
    timer = Timer(seconds, onCompleted);
  }

  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  /// Checking Initialized

  bool initialized = false;

  void setInitialized(bool value) {
    initialized = value;
  }

  void initialize() {
    setInitialized(true);
  }

  void deInitialize() {
    setInitialized(false);
  }
}
