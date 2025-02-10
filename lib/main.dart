import 'package:beseech/navigator/navigator_bloc.dart';
import 'package:beseech/objectbox.g.dart';
import 'package:beseech/settings/settings_bloc.dart';
import 'package:beseech/splash/splash_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'main.dart';

export 'dart:convert';
export 'dart:io';
export 'package:beseech/prayers/remainig_prayers.dart';
export 'package:beseech/prayers/prayers_page.dart';
export 'package:beseech/_archived_code/initial_page.dart';
export 'package:beseech/_archived_code/colors/material_colors_ui.dart';
export 'package:beseech/settings/settings_page.dart';
export 'package:clay_containers/clay_containers.dart';
export 'package:dots_indicator/dots_indicator.dart';
export 'package:flex_color_scheme/flex_color_scheme.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:manager/manager.dart';
// export 'package:path_provider/path_provider.dart';
// export 'package:states_rebuilder/scr/state_management/common/logger.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:uuid/uuid.dart';

late Store store;

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  final appInfo = await PackageInfo.fromPlatform();
  store = await openStore(
    directory:
        '${(await getApplicationDocumentsDirectory()).path}${appInfo.appName}',
  );
  await RM.storageInitializer(HiveStorage());
  runApp(const App());
}

class App extends UI {
  const App({super.key});
  @override
  void didMountWidget(_) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorBloc.key,
      // theme: FlexThemeData.light(
      //   // scaffoldBackground: color.shade900,
      //   colors: FlexSchemeColor(
      //     primary: color,
      //     secondary: color,
      //   ),
      //   useMaterial3: true,
      // ),
      // darkTheme: FlexThemeData.dark(
      //   useMaterial3: true,
      //   colors: FlexSchemeColor(
      //     primary: color,
      //     secondary: Colors.black,
      //   ),
      // ),
      themeMode: settingsBloc.themeMode,
      home: SplashPage(),
    );
  }
}

void _backgroundImages() {
  /// TODO - add background images to the app
  /// TODO - add different colors of themes
}
