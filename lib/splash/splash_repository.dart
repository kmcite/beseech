import 'package:beseech/main.dart';

final splashRepository = SplashRepository();

class SplashRepository {
  /// Timer for navigation from Splash -> Home / Initial
  Timer? timer;
  void createTimer(Duration seconds, void Function() callback) {
    timer = Timer(seconds, callback);
  }

  void dispose() {
    timer?.cancel();
    timer = null;
  }

  /// Checking Initialized
  final initializedRM = RM.inject<bool>(
    () => false,
    persist: () => PersistState(key: 'initialized'),
  );
  bool get initialized => initializedRM.state;

  void setInitialized(bool value) {
    initializedRM.state = value;
  }

  void initialize() {
    setInitialized(true);
  }

  void deInitialize() {
    setInitialized(false);
  }
}
