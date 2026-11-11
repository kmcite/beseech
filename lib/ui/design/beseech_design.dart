import 'package:flutter/material.dart';
import 'package:shared_database/app/liquid_theme.dart';

/// Beseech spacing and typography aligned with [LiquidTheme] radii.
abstract final class BeseechSpace {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;

  static const EdgeInsets page =
      EdgeInsets.fromLTRB(20, 6, 20, 28);

  static const EdgeInsets cardInset = EdgeInsets.all(LiquidTheme.radiusMd);

  static SizedBox get gapXs => const SizedBox(height: xs, width: xs);
  static SizedBox get gapSm => const SizedBox(height: sm, width: sm);
  static SizedBox get gapMd => const SizedBox(height: md, width: md);
  static SizedBox get gapLg => const SizedBox(height: lg, width: lg);
}

abstract final class BeseechColors {
  static const ada = Color(0xFF059669);
  static const adaContainer = Color(0xFFD1FAE5);
  static const awaiting = Color(0xFF2563EB);
  static const awaitingContainer = Color(0xFFDBEAFE);
  static const qaza = Color(0xFFDC2626);
  static const qazaContainer = Color(0xFFFEE2E2);
  static const accentWarm = Color(0xFFF59E0B);
}

extension BeseechTypography on BuildContext {
  ColorScheme get scheme => Theme.of(this).colorScheme;

  TextStyle get sectionTitle => Theme.of(this).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      );

  TextStyle get cardTitle => Theme.of(this).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      );

  TextStyle get bodyStrong => Theme.of(this).textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: scheme.onSurface,
      );

  TextStyle get fieldLabel => Theme.of(this).textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: scheme.onSurfaceVariant,
      );

  TextStyle get muted => Theme.of(this).textTheme.bodyMedium!.copyWith(
        color: scheme.onSurfaceVariant,
        height: 1.4,
      );

  TextStyle get statValue => Theme.of(this).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: scheme.onSurface,
      );

  TextStyle get statLabel => Theme.of(this).textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurfaceVariant,
      );
}
