import 'package:flutter/foundation.dart';
import 'package:shared_database/shared_database.dart';

import '../collections.dart';

class DatabaseService extends ChangeNotifier {
  bool _ready = false;

  bool get isReady => _ready;

  SharedDatabase get db {
    if (!_ready) {
      throw StateError('DatabaseService.init() must complete first.');
    }
    return SharedDatabase.instance;
  }

  Future<void> init() async {
    await SharedDatabase.attachAndVerify();
    final database = SharedDatabase.instance;
    await database.ensure(BeseechCollections.prayers);
    await database.ensure(BeseechCollections.user);
    await database.ensure(BeseechCollections.settings);
    _ready = true;
    notifyListeners();
  }
}
