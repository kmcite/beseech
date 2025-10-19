import 'package:beseech/domain/repositories/splash_repository.dart';
import 'package:beseech/objectbox.g.dart';
import 'package:beseech/ui/splash/splash_page.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/theme.dart';

import 'domain/repositories/prayers_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'utils/navigator.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  AppRunner(
    initialize: () async {
      /// SERVICES
      final store = await openStore();
      find(store);

      /// REPOSITORIES
      put(SplashRepository());
      put(SettingsRepository());
      put(PrayersRepository());
    },
    app: App(),
  );
}

class AppBloc extends Bloc {
  late final SettingsRepository settingsRepository = watch();

  bool get dark => settingsRepository.dark;
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }
}

class App extends UI<AppBloc> {
  const App({super.key});

  @override
  AppBloc create() => AppBloc();

  @override
  Widget build(BuildContext context, controller) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.navigatorKey,
      builder: (context, child) => FTheme(
        data: controller.dark ? FThemes.yellow.dark : FThemes.yellow.light,
        child: child!,
      ),
      themeMode: controller.dark ? ThemeMode.dark : ThemeMode.light,
      home: SplashPage(),
    );
  }
}
