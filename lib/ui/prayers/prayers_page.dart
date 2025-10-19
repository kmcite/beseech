import 'package:beseech/domain/repositories/prayers_repository.dart';
import 'package:beseech/ui/prayers/create_prayer.dart';
import 'package:beseech/ui/settings/informations/informations_page.dart';
import 'package:beseech/domain/repositories/user_repository.dart';
import 'package:beseech/ui/settings/settings_page.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:beseech/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../domain/models/prayer.dart';

class PrayersBloc extends Bloc {
  static const fourteenYears = Duration(days: 365 * 14);
  late final PrayersRepository prayersRepository = watch();

  Iterable<Prayer> get prayers => prayersRepository.box.getAll();
  void put(Prayer prayer) {
    prayersRepository.put(prayer);
  }

  int get qazaPrayersCount {
    return prayers.fold(
      0,
      (old, prayer) => old + prayer.qazaCount,
    );
  }

  int get adaPrayersCount {
    return prayers.fold(
      0,
      (old, prayer) => old + prayer.adaCount,
    );
  }

  int get awaitingPrayersCount {
    return prayers.fold(
      0,
      (value, prayer) => value + prayer.awaitingCount,
    );
  }

  void remove(Prayer prayer) {
    // prayersRepository.remove(prayer.id);
  }

  DateTime get dateOfPuberty => userRepository.user.dateOfPuberty;
  void handleDateOfPuberty(context, Prayer prayer) async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: dateOfPuberty,
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      put(prayer..date = selectedDate);
    }
  }

  void handleCreateNewPrayer() async {
    final now = DateTime.now();
    final existsByDate = prayersRepository.existsByDate(now);
    if (existsByDate) {
      navigator.dialog(PrayerExistsDialog());
    } else {
      final newPrayer = Prayer()..date = now;
      final prayer = await navigator.dialog(CreatePrayer(newPrayer));
      if (prayer != null) prayersRepository.put(prayer);
    }
  }
}

class PrayersPage extends UI<PrayersBloc> {
  @override
  PrayersBloc create() => PrayersBloc();

  const PrayersPage({super.key});
  @override
  Widget build(context, controller) {
    return FScaffold(
      header: FHeader(
        title: 'BESEECH'.text(),
        suffixes: [
          FButton.icon(
            onPress: () {
              navigator.dialog(InformationsPage());
            },
            child: Icon(FIcons.info),
          ),
          FButton.icon(
            onPress: () {
              navigator.to(SettingsPage());
            },
            child: Icon(FIcons.settings),
          ),
          FButton.icon(
            onPress: controller.handleCreateNewPrayer,
            child: Icon(FIcons.plus),
          ),
        ],
      ),
      child: Column(
        children: [
          Column(
            children: [
              'Incomplete'.text(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${controller.qazaPrayersCount}'),
                  Icon(Icons.cancel, color: Colors.red),
                ],
              ),
              // 'Completed'.text(textScaleFactor: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // adaPrayersCount.text(textScaleFactor: 2.6),
                  // Icon(Icons.check_circle, color: Colors.green).pad(),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: FTileGroup.builder(
              divider: FItemDivider.full,
              physics: BouncingScrollPhysics(),
              count: controller.prayers.length,
              tileBuilder: (context, index) {
                return FeatureScoped(
                  create: () {
                    final prayer = controller.prayers.elementAt(index);
                    return PrayerBloc(prayer.id);
                  },
                  builder: (context, prayerController, index) {
                    final prayer = controller.prayers.elementAt(index);

                    return FTile(
                      title: prayer.text(),
                      subtitle: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildPrayerChip(
                            'Fajr',
                            prayerController.prayer,
                            prayer.fajrStatus,
                          ),
                          _buildPrayerChip(
                            'Zuhr',
                            prayerController.prayer,
                            prayer.zuhrStatus,
                          ),
                          _buildPrayerChip(
                            'Asr',
                            prayerController.prayer,
                            prayer.asrStatus,
                          ),
                          _buildPrayerChip(
                            'Maghrib',
                            prayerController.prayer,
                            prayer.maghribStatus,
                          ),
                          _buildPrayerChip(
                            'Isha',
                            prayerController.prayer,
                            prayer.ishaStatus,
                          ),
                        ],
                      ),
                    );
                  },
                  param: index,
                );
              },
              description: 'All the prayers that are missing '.text(),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildPrayerCard(BuildContext context, Prayer prayer) {
    return FTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FButton(
                onPress: () {
                  // handleDateOfPuberty(context, prayer());
                },
                child: Text(
                  '${prayer.date.humanReadable}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 8),
              FButton.icon(
                style: prayer.adaCount < 5
                    ? FButtonStyle.ghost()
                    : FButtonStyle.destructive(),
                onPress: prayer.adaCount < 5
                    ? null
                    : () {
                        // remove(prayer());
                      },
                child: Icon(FIcons.delete),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPrayerChip(
    String label,
    VoidCallback onTap,
    PrayerStatus value,
  ) {
    return FButton.icon(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          SizedBox(width: 4),
          Icon(
            switch (value) {
              PrayerStatus.prayed => Icons.check_circle,
              PrayerStatus.notPrayed => Icons.cancel,
              PrayerStatus.awaiting => Icons.access_time,
            },
            // size: 16,
            color: switch (value) {
              PrayerStatus.prayed => Colors.green,
              PrayerStatus.notPrayed => Colors.red,
              PrayerStatus.awaiting => Colors.blue,
            },
          ),
        ],
      ),
      onPress: () => onTap(),
    );
  }
}

class PrayerBloc extends ScopedBloc<int> {
  late final PrayersRepository prayersRepository = watch();

  PrayerBloc(super.param);

  Prayer prayer([Prayer? value]) {
    print('called $value');
    if (value != null) {
      prayersRepository.put(value);
    }
    return prayersRepository.box.get(param)!;
  }
}
