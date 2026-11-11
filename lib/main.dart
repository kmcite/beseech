import 'package:beseech/app/bootstrap.dart';
import 'package:beseech/business/configuration.dart';
import 'package:beseech/core/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_database/app/liquid_theme.dart';

ThemeData _refined(ThemeData base) {
  return base.copyWith(
    dividerColor: base.colorScheme.outline.withValues(alpha: 0.35),
    listTileTheme: ListTileThemeData(
      iconColor: base.colorScheme.onSurfaceVariant,
      textColor: base.colorScheme.onSurface,
    ),
    chipTheme: ChipThemeData(
      side: BorderSide(
        color: base.colorScheme.outline.withValues(alpha: 0.35),
      ),
      labelStyle: TextStyle(
        color: base.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        foregroundColor: base.colorScheme.primary,
        side: BorderSide(
          color: base.colorScheme.outline.withValues(alpha: 0.45),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 3,
      extendedSizeConstraints: const BoxConstraints(minHeight: 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LiquidTheme.radiusLg),
      ),
    ),
  );
}

Future<void> main() async {
  final root = await bootstrap();
  runApp(root);
}

class BeseechApp extends StatelessWidget {
  const BeseechApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configuration = context.watch<ConfigurationController>();
    final router = context.read<AppRouter>();

    return MaterialApp.router(
      routerConfig: router.config,
      debugShowCheckedModeBanner: false,
      theme: _refined(LiquidTheme.light()),
      darkTheme: _refined(LiquidTheme.dark()),
      themeMode: configuration.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
