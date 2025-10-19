import 'package:beseech/domain/models/prayer.dart';
import 'package:beseech/domain/repositories/prayers_repository.dart';
import 'package:beseech/ui/settings/informations/informations_page.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../utils/navigator.dart';

class CreatePrayer extends UI<CreatePrayerBloc> {
  final Prayer prayer;
  const CreatePrayer(this.prayer);
  @override
  Widget build(context, controller) {
    return FDialog(
      title: 'Create new prayer'.text(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          'Do you want to create a new prayer?'.text(),
          FDivider(),
          prayer.date.humanReadable.text(),
          FDivider(),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(
          onPress: () => controller.savePrayer(),
          child: 'Yes'.text(),
        ),
        FButton(
          onPress: () => navigator.back(),
          child: 'No'.text(),
        ),
      ],
    );
  }

  @override
  CreatePrayerBloc create() => CreatePrayerBloc(prayer);
}

class CreatePrayerBloc extends Bloc {
  Prayer prayer;
  CreatePrayerBloc(this.prayer);
  late final prayersRepository = watch<PrayersRepository>();

  void savePrayer() {
    navigator.back(prayer);
  }
}

class PrayerExistsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: 'Prayer already exists'.text(),
      body: 'You already have a prayer for today'.text(),
      actions: [
        FButton(
          onPress: () => navigator.back(),
          child: 'OK'.text(),
        ),
      ],
    );
  }
}
