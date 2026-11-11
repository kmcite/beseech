import 'package:beseech/business/configuration.dart';
import 'package:beseech/business/information.dart';
import 'package:beseech/business/prayers.dart';
import 'package:beseech/domain/models/prayer_slot.dart';
import 'package:beseech/domain/models/prayer_status.dart';
import 'package:beseech/ui/dashboard/day_strip.dart';
import 'package:beseech/ui/dashboard/prayer_slot_card.dart';
import 'package:beseech/ui/dashboard/remaining_hero.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/formatting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayers = context.watch<PrayersController>();
    final profile = context.watch<InformationController>();
    final config = context.watch<ConfigurationController>();
    final ledger = prayers.ledger(profile.user);
    final selected = config.selectedDate;
    final dayPrayer = prayers.prayerOn(selected);

    final greeting = profile.user.name.trim().isEmpty
        ? 'Assalamu alaikum'
        : 'Salam, ${profile.user.name.trim()}';

    return SafeArea(
      child: Padding(
        padding: BeseechSpace.page,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(greeting, style: context.sectionTitle),
                  const SizedBox(height: 4),
                  Text(selected.humanReadable, style: context.muted),
                  BeseechSpace.gapMd,
                  RemainingHeroCard(ledger: ledger),
                  BeseechSpace.gapMd,
                  const DayStrip(),
                  BeseechSpace.gapMd,
                  const LiquidSectionHeader(
                    title: 'Mark your salat',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap each row: pending → prayed → missed',
                    style: context.muted,
                  ),
                  BeseechSpace.gapSm,
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final slot = PrayerSlot.values[index];
                  final status = dayPrayer?.statusFor(slot) ??
                      PrayerStatus.awaiting;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: BeseechSpace.sm),
                    child: PrayerSlotCard(
                      slot: slot,
                      status: status,
                      onTap: () => prayers.cycleSlot(selected, slot),
                    ),
                  );
                },
                childCount: PrayerSlot.values.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 88)),
          ],
        ),
      ),
    );
  }
}
