import 'package:beseech/domain/services/prayer_ledger.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:flutter/material.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class RemainingHeroCard extends StatelessWidget {
  const RemainingHeroCard({super.key, required this.ledger});

  final PrayerLedger ledger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = ledger.completionRatio;

    return LiquidSurface(
      highlight: true,
      padding: const EdgeInsets.all(BeseechSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Remaining', style: context.fieldLabel),
                    const SizedBox(height: 6),
                    Text(
                      '${ledger.remainingPrayers}',
                      style: context.statValue.copyWith(
                        fontSize: 40,
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      'prayers to restore',
                      style: context.muted,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      backgroundColor:
                          scheme.surfaceContainerHighest.withValues(alpha: 0.8),
                      color: BeseechColors.ada,
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: context.statLabel.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BeseechSpace.gapMd,
          Row(
            children: [
              _MiniStat(
                label: 'Today left',
                value: '${ledger.todayRemaining}',
                tone: BeseechColors.awaiting,
              ),
              BeseechSpace.gapSm,
              _MiniStat(
                label: 'Qaza',
                value: '${ledger.lifetimeQaza}',
                tone: BeseechColors.qaza,
              ),
              BeseechSpace.gapSm,
              _MiniStat(
                label: 'Unlogged days',
                value: '${ledger.unloggedDays}',
                tone: BeseechColors.accentWarm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LiquidSurface(
        variant: LiquidVariant.chip,
        padding: const EdgeInsets.symmetric(
          horizontal: BeseechSpace.sm,
          vertical: BeseechSpace.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.statValue.copyWith(
                fontSize: 20,
                color: tone,
              ),
            ),
            Text(label, style: context.statLabel, maxLines: 1),
          ],
        ),
      ),
    );
  }
}
