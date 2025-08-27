import 'package:hive/hive.dart';

class GlobalStorageKey {
  const GlobalStorageKey._();
  static const globalStorage = 'globalStorage';
}

abstract class GlobalStorage {
  Future<void> init();

}
class GlobalStorageImpl extends GlobalStorage {
  late Box _box;
  @override
  Future<void> init() async {
    _box = await Hive.openBox('globalStorage');

  }
}