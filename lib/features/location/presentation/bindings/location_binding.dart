import 'package:get/get.dart';

import '../controller/location_controller.dart';
import '../../../dashboard/presentation/controller/dashboard_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(
      () => LocationController(),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      fenix: true,
    );
  }
}
