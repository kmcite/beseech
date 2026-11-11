import 'package:beseech/domain/models/prayer_slot.dart';
import 'package:beseech/domain/models/prayer_status.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/prayer_visuals.dart';
import 'package:flutter/material.dart';
import 'package:shared_database/app/liquid_theme.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class PrayerSlotCard extends StatelessWidget {
  const PrayerSlotCard({
    super.key,
    required this.slot,
    required this.status,
    required this.onTap,
  });

  final PrayerSlot slot;
  final PrayerStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = prayerStatusColor(status, scheme);

    return LiquidSurface(
      highlight: status == PrayerStatus.prayed,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: BeseechSpace.md,
        vertical: BeseechSpace.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(LiquidTheme.radiusMd),
              border: Border.all(color: tone.withValues(alpha: 0.35)),
            ),
            child: Icon(slot.icon, color: tone),
          ),
          const SizedBox(width: BeseechSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot.label, style: context.cardTitle),
                Text(slot.hint, style: context.muted),
              ],
            ),
          ),
          _StatusBadge(status: status, tone: tone),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.tone});

  final PrayerStatus status;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return LiquidSurface(
      variant: LiquidVariant.chip,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(prayerStatusIcon(status), size: 18, color: tone),
          const SizedBox(width: 6),
          Text(
            prayerStatusLabel(status),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: tone,
            ),
          ),
        ],
      ),
    );
  }
}
