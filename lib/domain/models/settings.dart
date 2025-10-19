class Settings {
  double borderRadius = 8;
  double padding = 8;
  bool isDark = false;
  int colorIndex = 0;

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
