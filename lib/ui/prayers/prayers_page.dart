import 'package:beseech/business/business.dart';
import 'package:beseech/business/prayers_repository.dart';
import 'package:beseech/ui/settings/informations/informations_page.dart';
import 'package:beseech/ui/settings/settings_page.dart';
import 'package:beseech/ui/prayers/create_prayer.dart';
import 'package:beseech/utils/extensions.dart';
import 'package:beseech/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:fountain/fountain.dart';
import 'package:beseech/domain/models/prayer.dart';

class PrayersPage extends StatelessWidget {
  const PrayersPage({super.key});

  @override
  Widget build(context) {
    final prayers = context.state.prayers;
    final selectedDate = context.state.selectedDate;
    final totalQaza = prayers.fold(
      0,
      (old, prayer) => old + prayer.qazaCount,
    );
    final totalAda = prayers.fold(
      0,
      (old, prayer) => old + prayer.adaCount,
    );
    final totalAwaiting = prayers.fold(
      0,
      (sum, prayer) => sum + prayer.awaitingCount,
    );
    return FScaffold(
      header: FHeader(
        title: 'BESEECH'.text(),
        suffixes: [
          FButton.icon(
            onPress: () => navigator.dialog(InformationsPage()),
            child: const Icon(FIcons.info),
          ),
          FButton.icon(
            onPress: () => navigator.to(SettingsPage()),
            child: const Icon(FIcons.settings),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: FCard(
              child: Column(
                children: [
                  FLineCalendar(
                    control: FLineCalendarControl.lifted(
                      date: selectedDate,
                      onChange: (value) {
                        if (value != null) {
                          context.apply(ChangeSelectedDate(value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Selected Date'),
                      Text(selectedDate.humanReadable),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: FCard(
              child: Column(
                children: [
                  'Prayer Summary'.text(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Completed',
                        totalAda,
                        Colors.green,
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        'Missed',
                        totalQaza,
                        Colors.red,
                        Icons.cancel,
                      ),
                      _buildStatItem(
                        'Pending',
                        totalAwaiting,
                        Colors.blue,
                        Icons.access_time,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (prayers.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FIcons.calendar, size: 64),
                    const SizedBox(height: 16),
                    'No prayers recorded yet'.text(),
                    const SizedBox(height: 8),
                    'Start tracking your daily prayers'.text(),
                    const SizedBox(height: 24),
                    FButton(
                      onPress: () => _handleCreateNewPrayer(context),
                      child: 'Add First Prayer'.text(),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'Prayer Records'.text(),
                      FButton.icon(
                        onPress: () => _handleCreateNewPrayer(context),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FIcons.plus),
                            SizedBox(width: 4),
                            Text('Add Prayer'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FTileGroup.builder(
                    divider: FItemDivider.full,
                    physics: const BouncingScrollPhysics(),
                    count: prayers.length,
                    tileBuilder: (context, index) {
                      final prayer = prayers.elementAt(index);
                      return _buildPrayerTile(context, prayer);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPrayerTile(BuildContext context, Prayer prayer) {
    return FTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              prayer.date.humanReadable.text(),
              const SizedBox(height: 4),
              Row(
                children: [
                  '${prayer.adaCount}/5'.text(),
                  const SizedBox(width: 8),
                  if (prayer.qazaCount > 0) '${prayer.qazaCount} missed'.text(),
                ],
              ),
            ],
          ),
          FButton.icon(
            onPress: () => _showPrayerDetails(context, prayer),
            child: const Icon(FIcons.chevronRight),
          ),
        ],
      ),
      subtitle: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          _buildPrayerChip('Fajr', prayer.fajrStatus),
          _buildPrayerChip('Zuhr', prayer.zuhrStatus),
          _buildPrayerChip('Asr', prayer.asrStatus),
          _buildPrayerChip('Maghrib', prayer.maghribStatus),
          _buildPrayerChip('Isha', prayer.ishaStatus),
        ],
      ),
    );
  }

  Widget _buildPrayerChip(String label, PrayerStatus status) {
    final color = switch (status) {
      PrayerStatus.prayed => Colors.green,
      PrayerStatus.notPrayed => Colors.red,
      PrayerStatus.awaiting => Colors.blue,
    };

    final icon = switch (status) {
      PrayerStatus.prayed => Icons.check_circle,
      PrayerStatus.notPrayed => Icons.cancel,
      PrayerStatus.awaiting => Icons.access_time,
    };

    return FButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: color),
        ],
      ),
      onPress: () {},
    );
  }

  void _handleCreateNewPrayer(BuildContext context) {
    final now = DateTime.now();
    final newPrayer = Prayer()..date = now;

    navigator.dialog(CreatePrayer(newPrayer)).then((result) {
      if (result != null) {
        context.dispatch<Business>(AddPrayerAction(result));
      }
    });
  }

  void _showPrayerDetails(BuildContext context, Prayer prayer) {
    navigator.dialog(
      FDialog(
        title: 'Prayer Details'.text(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            prayer.date.humanReadable.text(),
            const SizedBox(height: 16),
            ...['Fajr', 'Zuhr', 'Asr', 'Maghrib', 'Isha'].map((prayerName) {
              final status = switch (prayerName) {
                'Fajr' => prayer.fajrStatus,
                'Zuhr' => prayer.zuhrStatus,
                'Asr' => prayer.asrStatus,
                'Maghrib' => prayer.maghribStatus,
                'Isha' => prayer.ishaStatus,
                _ => PrayerStatus.awaiting,
              };

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    prayerName.text(),
                    Row(
                      children: [
                        Icon(
                          switch (status) {
                            PrayerStatus.prayed => Icons.check_circle,
                            PrayerStatus.notPrayed => Icons.cancel,
                            PrayerStatus.awaiting => Icons.access_time,
                          },
                          color: switch (status) {
                            PrayerStatus.prayed => Colors.green,
                            PrayerStatus.notPrayed => Colors.red,
                            PrayerStatus.awaiting => Colors.blue,
                          },
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        switch (status) {
                          PrayerStatus.prayed => 'Prayed'.text(),
                          PrayerStatus.notPrayed => 'Missed'.text(),
                          PrayerStatus.awaiting => 'Pending'.text(),
                        },
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          FButton(
            onPress: () => navigator.back(),
            child: 'Close'.text(),
          ),
        ],
      ),
    );
  }
}
