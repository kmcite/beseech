import 'package:beseech/business/prayers.dart';
import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/models/prayer_slot.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/formatting.dart';
import 'package:beseech/ui/prayer_visuals.dart';
import 'package:beseech/ui/widgets/beseech_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayers = context.watch<PrayersController>();
    final records = prayers.records;

    return SafeArea(
      child: Padding(
        padding: BeseechSpace.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('History', style: context.sectionTitle),
            Text(
              'Every day you have logged',
              style: context.muted,
            ),
            BeseechSpace.gapMd,
            Expanded(
              child: records.isEmpty
                  ? const LiquidEmptyState(
                      icon: Icons.history_rounded,
                      message: 'No logged days yet.\nStart on the Today tab.',
                    )
                  : ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (_, _) => BeseechSpace.gapSm,
                      itemBuilder: (context, index) {
                        return _HistoryTile(prayer: records[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.prayer});

  final Prayer prayer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BeseechSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(prayer.date.humanReadable, style: context.cardTitle),
          BeseechSpace.gapSm,
          Row(
            children: [
              BeseechSummaryStat(
                label: 'Ada',
                value: '${prayer.adaCount}',
                icon: Icons.check_circle_rounded,
                tone: BeseechColors.ada,
              ),
              BeseechSpace.gapSm,
              BeseechSummaryStat(
                label: 'Qaza',
                value: '${prayer.qazaCount}',
                icon: Icons.cancel_rounded,
                tone: BeseechColors.qaza,
              ),
              BeseechSpace.gapSm,
              BeseechSummaryStat(
                label: 'Left',
                value: '${prayer.awaitingCount}',
                icon: Icons.schedule_rounded,
                tone: BeseechColors.awaiting,
              ),
            ],
          ),
          BeseechSpace.gapSm,
          Wrap(
            spacing: BeseechSpace.xs,
            runSpacing: BeseechSpace.xs,
            children: [
              for (final slot in PrayerSlot.values)
                LiquidPill(
                  icon: prayerStatusIcon(prayer.statusFor(slot)),
                  label: slot.label,
                  tone: prayerStatusColor(prayer.statusFor(slot), scheme),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
