import 'package:beseech/business/business.dart';
import 'package:beseech/utils/architecture.dart';
import 'package:fountain/fountain.dart';

class SettingsRepository extends Repository {
  bool dark = false;
  toggle() {
    dark = !dark;
    notify('toggle<$dark>');
  }
}

class DarkToggledAction extends Action<Business> {
  @override
  call(context) async* {
    yield (state) {
      return state..dark = !state.dark;
    };
  }
}
