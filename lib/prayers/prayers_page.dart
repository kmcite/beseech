import 'package:beseech/prayers/prayers_bloc.dart';
import 'package:beseech/prayers/prayers_list.dart';
import 'package:beseech/main.dart';
import 'package:beseech/navigator/navigator_bloc.dart';
import 'package:beseech/prayers/prayers_repository.dart';
import 'package:beseech/settings/informations/informations_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PrayersPage extends UI {
  const PrayersPage({super.key});
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: 'BESEECH'.text(textScaleFactor: 1).pad(),
        automaticallyImplyLeading: false,
        actions: [
          ShadButton(
            onPressed: () {
              navigatorBloc.dialog(
                Dialog(
                  child: InformationsPage(),
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
          ShadButton(
            onPressed: () => navigatorBloc.to(SettingsPage()),
            icon: const Icon(Icons.settings),
          ).pad(right: 8),
        ],
      ),
      body: PrayerList(),
      floatingActionButton: ShadButton(
        onPressed: () {
          prayersBloc.put(Prayer());
        },
        child: 'Add'.text(),
        icon: Icon(Icons.add),
      ),
    );
  }
}
