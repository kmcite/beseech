import 'dart:async';

import 'package:beseech/domain/collections.dart';
import 'package:beseech/domain/models/settings.dart';
import 'package:beseech/domain/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_database/shared_database.dart';

class ConfigurationRepository extends ChangeNotifier {
  ConfigurationRepository(this._database) {
    _database.addListener(notifyListeners);
  }

  final DatabaseService _database;
  Settings _settings = Settings();
  StreamSubscription<SharedRecord?>? _watch;

  Settings get settings => _settings;
  bool get isReady => _database.isReady;

  Future<void> init() async {
    final record = await _database.db.get(
      BeseechCollections.settings,
      BeseechRecordIds.appSettings,
    );
    if (record != null) {
      _settings = Settings.fromJson(record.data);
    }
    _watch = _database.db
        .watchRecord(BeseechCollections.settings, BeseechRecordIds.appSettings)
        .listen((record) {
      if (record != null) {
        _settings = Settings.fromJson(record.data);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> save(Settings value) async {
    _settings = value;
    notifyListeners();
    await _database.db.put(
      BeseechCollections.settings,
      value.toJson(),
      id: BeseechRecordIds.appSettings,
    );
  }

  @override
  void dispose() {
    _watch?.cancel();
    _database.removeListener(notifyListeners);
    super.dispose();
  }
}
