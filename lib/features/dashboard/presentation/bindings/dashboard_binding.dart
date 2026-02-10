import 'package:get/get.dart';

import '../controller/dash_controller.dart';
import '../../../location/presentation/controller/location_controller.dart';

import '../../../cart/presentation/controllers/cart_controller.dart';

import '../../../notification/presentation/controllers/notification_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    /// Dashboard Controller
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      fenix: true,
    );

    /// Cart Controller (for BottomNav badge)
    Get.lazyPut<CartController>(
      () => CartController(),
      fenix: true,
    );

    /// Location Controller (used in dashboard & location dialog)
    Get.lazyPut<LocationController>(
      () => LocationController(),
      fenix: true,
    );

    /// Notification Controller (used in BottomNavBar)
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
  }
}
