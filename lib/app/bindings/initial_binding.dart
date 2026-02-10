import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/storage_service.dart';
import '../../core/network/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    final prefs = await SharedPreferences.getInstance();

    Get.put(
      StorageService(prefs),
      permanent: true,
    );

    Get.put(
      ApiClient(),
      permanent: true,
    );
  }
}
