import 'package:beseech/main.dart';

final SettingsRepository settingsRepository = SettingsRepository();

class SettingsRepository {
  final settingsRM = rms(
    Settings(),
    persisted: () => persisted(
      'settings',
      Settings.fromJson,
    ),
  );

  Settings get settings => settingsRM.state;

  void setSettings(Settings value) {
    settingsRM
      ..state = value
      ..notify();
  }

  double get padding => settings.padding ?? 8;
  double get borderRadius => settings.borderRadius ?? 8;
  MaterialColor get color => Colors.primaries[settings.colorIndex ?? 0];
  ThemeMode get themeMode {
    return settings.isDark ?? false ? ThemeMode.dark : ThemeMode.light;
  }

  void setBorderRadius(double value) {
    return setSettings(settings..borderRadius = value);
  }

  void setPadding(double value) {
    setSettings(settings..padding = value);
  }

  void setThemeMode(ThemeMode? value) {
    setSettings(settings..isDark = value == ThemeMode.dark);
  }

  void setColor(MaterialColor value) {
    setSettings(settings..colorIndex = Colors.primaries.indexOf(value));
  }
}

class Settings {
  double? borderRadius;
  double? padding;
  bool? isDark;
  int? colorIndex;

  Settings();

  Settings.fromJson(Map<String, dynamic> json)
      : borderRadius = json['borderRadius'] ?? 8,
        padding = json['padding'] ?? 8,
        isDark = json['isDark'] ?? false,
        colorIndex = json['colorIndex'] ?? 0;
  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'padding': padding,
      'isDark': isDark,
      'colorIndex': colorIndex,
    };
  }
}

abstract class ImageOrColor {
  MaterialColor? get color;
  File? get image;
  bool get isColor => color != null;
}
