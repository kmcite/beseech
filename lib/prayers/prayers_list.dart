import 'package:beseech/user/user_bloc.dart';
import 'package:beseech/main.dart';
import 'package:beseech/prayers/prayers_bloc.dart';
import 'package:beseech/settings/informations/informations_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'prayers_repository.dart';

class PrayerList extends UI {
  const PrayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemainingPrayers(),
        Expanded(
          flex: 2,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: prayersBloc.prayers.length,
            itemBuilder: (context, index) {
              return _buildPrayerCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerCard(BuildContext context, int index) {
    Prayer prayer([Prayer? update]) {
      if (update != null) prayersBloc.put(update);
      return prayersBloc.prayers.elementAt(index);
    }

    return ShadCard(
      // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // color: Colors.black12,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShadButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      firstDate: userBloc.dateOfPuberty,
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      prayersBloc.put(prayer()..date = selectedDate);
                    }
                  },
                  child: Text('${prayer().date.humanReadable}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8),
                ShadButton(
                  onPressed: prayer().adaCount < 5
                      ? null
                      : () {
                          prayersBloc.remove(prayer());
                        },
                  icon: Icon(Icons.delete_forever),
                )
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildPrayerChip(
                  'Fajr',
                  prayer,
                  () {
                    prayer(
                      prayer()
                        ..fajrStatus = switch (prayer().fajrStatus) {
                          PrayerStatus.prayed => PrayerStatus.notPrayed,
                          PrayerStatus.notPrayed => PrayerStatus.awaiting,
                          PrayerStatus.awaiting => PrayerStatus.prayed,
                        },
                    );
                  },
                  prayer().fajrStatus,
                ),
                _buildPrayerChip(
                  'Zuhr',
                  prayer,
                  () {
                    prayer(
                      prayer()
                        ..zuhrStatus = switch (prayer().zuhrStatus) {
                          PrayerStatus.prayed => PrayerStatus.notPrayed,
                          PrayerStatus.notPrayed => PrayerStatus.awaiting,
                          PrayerStatus.awaiting => PrayerStatus.prayed,
                        },
                    );
                  },
                  prayer().zuhrStatus,
                ),
                _buildPrayerChip(
                  'Asr',
                  prayer,
                  () {
                    prayer(
                      prayer()
                        ..asrStatus = switch (prayer().asrStatus) {
                          PrayerStatus.prayed => PrayerStatus.notPrayed,
                          PrayerStatus.notPrayed => PrayerStatus.awaiting,
                          PrayerStatus.awaiting => PrayerStatus.prayed,
                        },
                    );
                  },
                  prayer().asrStatus,
                ),
                _buildPrayerChip(
                  'Maghrib',
                  prayer,
                  () {
                    prayer(
                      prayer()
                        ..maghribStatus = switch (prayer().maghribStatus) {
                          PrayerStatus.prayed => PrayerStatus.notPrayed,
                          PrayerStatus.notPrayed => PrayerStatus.awaiting,
                          PrayerStatus.awaiting => PrayerStatus.prayed,
                        },
                    );
                  },
                  prayer().maghribStatus,
                ),
                _buildPrayerChip(
                  'Isha',
                  prayer,
                  () {
                    prayer(
                      prayer()
                        ..ishaStatus = switch (prayer().ishaStatus) {
                          PrayerStatus.prayed => PrayerStatus.notPrayed,
                          PrayerStatus.notPrayed => PrayerStatus.awaiting,
                          PrayerStatus.awaiting => PrayerStatus.prayed,
                        },
                    );
                  },
                  prayer().ishaStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerChip(String label, Prayer Function([Prayer?]) prayer,
      VoidCallback onTap, PrayerStatus value) {
    return ShadButton(
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
      onPressed: onTap,
    );
  }
}
