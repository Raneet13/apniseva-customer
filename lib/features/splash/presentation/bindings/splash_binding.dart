import 'package:get/get.dart';

import '../controller/splash_controller.dart';
import '../../../../core/storage/storage_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashController(
        Get.find<StorageService>(),
      ),
    );
  }
}
