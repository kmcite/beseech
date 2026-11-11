import 'package:beseech/business/configuration.dart';
import 'package:beseech/business/prayers.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/widgets/beseech_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_database/app/liquid_theme.dart';

class DayStrip extends StatelessWidget {
  const DayStrip({super.key});

  static final DateTime _anchor = DateTime.now().subtract(
    const Duration(days: 14),
  );

  static const _days = 45;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigurationController>();
    final prayers = context.watch<PrayersController>();
    final selected = config.selectedDate;
    final scheme = Theme.of(context).colorScheme;

    return BeseechSection(
      title: 'Day',
      child: SizedBox(
        height: 92,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _days,
          itemBuilder: (context, index) {
            final date = _anchor.add(Duration(days: index));
            final isSelected = _sameDay(date, selected);
            final hasLog = prayers.prayerOn(date) != null;

            return Padding(
              padding: const EdgeInsets.only(right: BeseechSpace.xs),
              child: InkWell(
                borderRadius: BorderRadius.circular(LiquidTheme.radiusMd),
                onTap: () => config.setSelectedDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? scheme.primary
                        : scheme.surfaceContainerHighest
                            .withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(LiquidTheme.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? scheme.primary
                          : scheme.outline.withValues(alpha: 0.35),
                      width: hasLog && !isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekday(date.weekday),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? scheme.onPrimary
                              : scheme.onSurface,
                        ),
                      ),
                      if (hasLog)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? scheme.onPrimary
                                : BeseechColors.ada,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _weekday(int day) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return labels[day - 1];
  }
}
