import 'package:beseech/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../../../domain/repositories/user_repository.dart';
import '../../../utils/architecture.dart';

class InformationBloc extends Bloc {
  Duration get age => userRepository.age;
  late final name = userRepository.name;
  late final editing = userRepository.editing;
  late final ageVysor = userRepository.ageVysor;
  late final knowsPubertyDate = userRepository.knowsPubertyDate;
  late final dateOfPuberty = userRepository.dateOfPuberty;
  late final dateOfBirth = userRepository.dateOfBirth;
}

class InformationsPage extends UI<InformationBloc> {
  @override
  InformationBloc create() => InformationBloc();

  const InformationsPage({super.key});

  @override
  Widget build(BuildContext context, controller) {
    return FDialog(
      title: "Informations".text(),
      direction: Axis.horizontal,
      body: Column(
        children: [
          Text('NAME'),
          FTextField(
            initialText: controller.name(),
            onChange: controller.name,
            onSubmit: (_) => controller.editing(false),
            maxLines: null,
          ),
          'DATE OF BIRTH'.text(),
          FButton(
            child: controller.dateOfBirth().humanReadable.text(),
            onPress: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: controller.dateOfBirth(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) controller.dateOfBirth(selectedDate);
            },
          ),
          'LIFE'.text(),
          ...AgeVysor.values.map(
            (av) {
              return FTile(
                prefix: Icon(
                  av == controller.ageVysor() ? Icons.timer : Icons.timer_off,
                ),
                title: av.name.toUpperCase().text(),
                onPress: av == controller.ageVysor()
                    ? null
                    : () {
                        controller.ageVysor(av);
                      },
              );
            },
          ),
          controller.ageVysor().ui(-controller.age),
        ],
      ),
      actions: [
        FButton(
          child: 'Okay'.text(),
          onPress: () => navigator.back(),
        ),
      ],
    );
  }
}

extension HumanReadable on DateTime {
  String get humanReadable => DateFormat('dd-MM-yyyy (EEEE)').format(this);
}
