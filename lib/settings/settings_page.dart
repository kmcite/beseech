import 'package:beseech/main.dart';
import 'package:beseech/settings/settings_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../navigator/navigator_bloc.dart';

class SettingsPage extends UI {
  /// DEPENDENCIES
  NavigatorBloc get _navigatorBloc => navigatorBloc;

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ShadButton(
                  icon: Icon(ThemeMode.light.icon),
                  onPressed: settingsBloc.themeMode == ThemeMode.light
                      ? null
                      : () {
                          settingsBloc.setThemeMode(ThemeMode.light);
                        },
                  child: ThemeMode.light.name.toUpperCase().text(),
                ),
              ),
              Expanded(
                child: ShadButton(
                  icon: Icon(ThemeMode.dark.icon),
                  onPressed: settingsBloc.themeMode == ThemeMode.dark
                      ? null
                      : () {
                          settingsBloc.setThemeMode(ThemeMode.dark);
                        },
                  child: ThemeMode.dark.name.toUpperCase().text(),
                ),
              )
            ],
          ).pad(),
          ShadButton.destructive(
            onPressed: () async {
              final shouldRestore = await navigatorBloc.dialog<bool>(
                Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      'Are you sure?'.text(textScaleFactor: 2).pad(),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                navigatorBloc.back(false);
                              },
                              label: 'NO'.text(),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FilledButton.icon(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                navigatorBloc.back(true);
                              },
                              label: 'YES'.text(),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ).pad()
                    ],
                  ),
                ),
              );
              if (shouldRestore == true) settingsBloc.restoreApp();
            },
            child: Text(
              'RESET APPLICATION',
            ),
          ).pad(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShadButton(
              onPressed: () {},
              child: Text(
                "COLORS",
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: CarouselView(
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              children: List<Widget>.generate(
                Colors.primaries.length,
                (int index) {
                  final color = Colors.primaries[index];
                  return Container(
                    color: color,
                  );
                },
              ),
              onTap: (value) {
                setColor(Colors.primaries[value]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension E on ThemeMode {
  IconData get icon {
    return switch (this) {
      ThemeMode.system => Icons.settings,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }
}

/// to be -> bloc,repo
final colorRM = RM.inject(() => Colors.amber);
MaterialColor get color => colorRM.state;
void setColor(MaterialColor val) => colorRM.state = val;
