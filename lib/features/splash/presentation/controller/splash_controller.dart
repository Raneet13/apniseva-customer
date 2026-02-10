import 'package:get/get.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/storage_keys.dart';

import '../../../../app/routes/route_names.dart';

class SplashController extends GetxController {
  final StorageService storage;

  SplashController(this.storage);

  @override
  void onInit() {
    super.onInit();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    final userId = storage.prefs.getString(StorageKeys.userId);

    if (userId == null) {
      Get.offAllNamed(RouteNames.registration);
    } else {
      Get.offAllNamed(RouteNames.dashboard);
    }
  }
}
