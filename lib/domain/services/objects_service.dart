import 'package:beseech/objectbox.g.dart' show openStore;
import 'package:objectbox/objectbox.dart' show Box, Store;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class ObjectsService {
  Store? store;
  Box<T> _box<T>() => store!.box<T>();
  Future<T> ensureInitialized<T>(Future<T> Function() action) async {
    if (store == null) {
      final path = await getApplicationDocumentsDirectory();
      store = await openStore(
        directory: join(path.path, 'beseech'),
      );
    }
    return await action.call();
  }

  Future<int> put<T>(T any) async {
    return await ensureInitialized(
      () => _box().putAsync(any),
    );
  }

  Future<bool> delete<T>(int id) async {
    return await ensureInitialized(
      () => _box().removeAsync(id),
    );
  }

  Future<T?> get<T>(int id) async {
    return await ensureInitialized(
      () => _box<T>().getAsync(id),
    );
  }

  Future<List<T>> getAll<T>() async {
    return await ensureInitialized(
      () => _box<T>().getAllAsync(),
    );
  }
}
