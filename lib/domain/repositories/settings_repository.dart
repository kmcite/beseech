import 'package:beseech/utils/architecture.dart';

class SettingsRepository extends Repository {
  bool dark = false;
  toggle() {
    dark = !dark;
    notify('toggle<$dark>');
  }
}
