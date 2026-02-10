import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class StorageService {
  final SharedPreferences prefs;

  StorageService(this.prefs);

  String? get userId => prefs.getString(StorageKeys.userId);

  Future<void> setUserId(String id) async {
    await prefs.setString(StorageKeys.userId, id);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}
