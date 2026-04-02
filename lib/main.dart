import 'dart:async';

import 'package:beseech/business/business.dart';
import 'package:beseech/ui/prayers/prayers_page.dart';
import 'package:beseech/ui/splash/splash_page.dart';
import 'package:beseech/utils/extensions.dart';
import 'package:beseech/domain/services/objects_service.dart';
import 'package:beseech/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/theme.dart';
import 'package:fountain/fountain.dart';

import 'utils/navigator.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  runApp(
    Fountain<Business>(
      initialState: (context) {
        return Business();
      },
      child: App(),
      services: [
        Service<Business, ObjectsService>(
          builder: (context) => ObjectsService(),
        ),
      ],
      middlewares: [
        Logging(),
        NativeSplashRemovalMW(),
        ActionExecutor<Business>(),
      ],
    ),
  );
}

class NativeSplashRemovalMW extends Middleware<Business> {
  Timer? timer;
  @override
  Stream<Business> call(
    Context<Business> context,
    Event event,
    NextMiddleware<Business> next,
  ) async* {
    if (timer == null && event is InitApplicationEvent) {
      timer = Timer(const Duration(seconds: 2), () {
        navigator.to(PrayersPage());
      });
    }
    FlutterNativeSplash.remove();
    yield* next(context, event);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.on((state) => state.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.navigatorKey,
      builder: (context, child) => FTheme(
        data: dark.choose(
          FThemes.yellow.dark,
          FThemes.yellow.light,
        ),
        child: child!,
      ),
      themeMode: dark.choose(
        ThemeMode.dark,
        ThemeMode.light,
      ),
      home: SplashPage(),
    );
  }
}
