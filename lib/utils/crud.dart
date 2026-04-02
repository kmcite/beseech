import 'package:beseech/utils/architecture.dart';
import 'package:objectbox/objectbox.dart';

mixin CRUD<T> {
  late final Box<T> box = find<Store>().box<T>();
  void put(T any) {
    box.put(any);
  }

  void remove(int id) {
    box.remove(id);
  }

  void removeAll() {
    box.removeAll();
  }

  T? byId(int id) => box.get(id);

  List<T> getAll() => box.getAll();
}
