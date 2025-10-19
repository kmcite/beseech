import 'package:beseech/ui/settings/settings_bloc.dart';
import 'package:beseech/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../utils/architecture.dart';

class SettingsPage extends UI<SettingsBloc> {
  @override
  SettingsBloc create() => SettingsBloc();

  const SettingsPage({super.key});

  @override
  Widget build(context, controller) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        title: const Text('SETTINGS'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FButton(
                  prefix: Icon(ThemeMode.light.icon),
                  onPress: controller.dark
                      ? () => controller.settingsRepository.toggle()
                      : null,
                  child: ThemeMode.light.name.toUpperCase().text(),
                ),
              ),
              Expanded(
                child: FButton(
                  prefix: Icon(ThemeMode.dark.icon),
                  onPress: controller.dark
                      ? null
                      : () => controller.settingsRepository.toggle(),
                  child: ThemeMode.dark.name.toUpperCase().text(),
                ),
              ),
            ],
          ),
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () async {
              final shouldRestore = await navigator.dialog<bool>(
                Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Are you sure?'),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                navigator.back(false);
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
                                navigator.back(true);
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              if (shouldRestore == true) controller.restoreApp();
            },
            child: Text('RESET APPLICATION'),
          ),
          FButton(onPress: () {}, child: Text("COLORS")),
          SizedBox(
            height: 180,
            child: CarouselView(
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              children: List<Widget>.generate(Colors.primaries.length, (
                int index,
              ) {
                final color = Colors.primaries[index];
                return Container(color: color);
              }),
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
var _color = Colors.amber;
MaterialColor get color => _color;
void setColor(MaterialColor val) {
  _color = val;
  // notifyListeners();
}
