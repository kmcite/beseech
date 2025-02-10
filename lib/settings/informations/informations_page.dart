import 'package:beseech/user/user_bloc.dart';
import 'package:beseech/navigator/navigator_bloc.dart';
import 'package:beseech/main.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../user/user_repository.dart';

class InformationsPage extends UI {
  const InformationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          "Informations".text(textScaleFactor: 2).pad(),
          const Divider(),
          'NAME'.text().pad(),
          if (userBloc.editing)
            ShadInput(
              initialValue: userBloc.userName,
              onChanged: userBloc.setUserName,
              onSubmitted: (_) => userBloc.setEditing(false),
            ).pad()
          else
            ShadButton(
              child: userBloc.userName.text(),
              onPressed: () => userBloc.setEditing(true),
            ).pad(),
          const Divider(),
          'DATE OF BIRTH'.text().pad(),
          ShadButton(
            child: userBloc.dateOfBirth.humanReadable.text(),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: userBloc.dateOfBirth,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) userBloc.setDateOfBirth(selectedDate);
            },
          ).pad(),
          const Divider(),
          'LIFE'.text().pad(),
          ShadSelect(
            initialValue: userBloc.ageVysor,
            options: AgeVysor.values
                .map(
                  (eachAgeVysor) => ShadOption(
                    value: eachAgeVysor,
                    child: eachAgeVysor.name.toUpperCase().text(),
                  ),
                )
                .toList(),
            onChanged: userBloc.setAgeVysor,
            selectedOptionBuilder: (context, value) {
              return value.name.toUpperCase().text();
            },
          ),
          userBloc.ageVysor.ui.pad(),
          const Divider(),
          ShadButton(
            onPressed: () => navigatorBloc.back(),
            child: 'Ok'.text(),
          ).pad(),
        ],
      ).pad(),
    );
  }
}

extension HumanReadable on DateTime {
  String get humanReadable => DateFormat('dd-MM-yyyy (EEEE)').format(this);
}
