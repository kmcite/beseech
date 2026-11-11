import 'dart:async';

import 'package:beseech/domain/collections.dart';
import 'package:beseech/domain/models/user.dart';
import 'package:beseech/domain/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_database/shared_database.dart';

class UserRepository extends ChangeNotifier {
  UserRepository(this._database);

  final DatabaseService _database;
  User _user = User();
  StreamSubscription<SharedRecord?>? _watch;

  User get user => _user;

  Future<void> init() async {
    final record = await _database.db.get(
      BeseechCollections.user,
      BeseechRecordIds.userProfile,
    );
    if (record != null) {
      _user = User.fromJson(record.data);
    }
    _watch = _database.db
        .watchRecord(BeseechCollections.user, BeseechRecordIds.userProfile)
        .listen((record) {
      if (record != null) {
        _user = User.fromJson(record.data);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> save(User value) async {
    _user = value;
    notifyListeners();
    await _database.db.put(
      BeseechCollections.user,
      value.toJson(),
      id: BeseechRecordIds.userProfile,
    );
  }

  Future<void> reset() => save(User());

  @override
  void dispose() {
    _watch?.cancel();
    super.dispose();
  }
}
