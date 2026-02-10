import 'package:apniseva/features/dashboard/views/dashboard_screen.dart';
import 'package:get/get.dart';

import '../routes/route_names.dart';

/// Splash
import '../../features/splash/presentation/views/splash_screen.dart';
import '../../features/splash/presentation/bindings/splash_binding.dart';

/// Auth
import '../../features/auth/presentation/views/registration_screen.dart';
import '../../features/auth/presentation/views/otp_screen.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';

/// Location
import '../../features/location/presentation/views/location_screen.dart';
import '../../features/location/presentation/bindings/location_binding.dart';

/// Dashboard Screen (Feature)
import '../../features/dashboard/presentation/views/dashboard_screen.dart';
import '../../features/dashboard/presentation/bindings/dashboard_binding.dart';

/// Bottom Nav Shell (Shared)
import '../../shared/widgets/navigation/app_bottom_navbar.dart';

import '../../features/cart/presentation/views/cart_screen.dart';
import '../../features/cart/presentation/bindings/cart_binding.dart';

class AppPages {
  static final pages = [
    /// Splash
    GetPage(
      name: RouteNames.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    /// Registration
    GetPage(
      name: RouteNames.registration,
      page: () => const RegistrationScreen(),
      binding: AuthBinding(),
    ),

    /// OTP
    GetPage(
      name: RouteNames.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
    ),

    /// Location
    GetPage(
      name: RouteNames.location,
      page: () => const LocationScreen(),
      binding: LocationBinding(),
    ),

    /// Dashboard Feature Screen
    GetPage(
      name: RouteNames.dashboard,
      page: () => const AppBottomNavBar(),
    ),

    GetPage(
      name: RouteNames.dashboardScreen,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: RouteNames.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
    ),
  ];
}
