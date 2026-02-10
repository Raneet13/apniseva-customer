import 'dart:io';

import 'package:apniseva/features/dashboard/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:remixicon/remixicon.dart';
import 'package:badges/badges.dart' as badges;

import '../../../app/theme/app_colors.dart';

import '../../../features/dashboard/presentation/views/dashboard_screen.dart';
import '../../../features/cart/presentation/controller/cart_controller.dart';
import '../../../features/cart/presentation/views/cart_screen.dart';
import '../../../features/orders/presentation/views/order_screen.dart';
import '../../../features/more/presentation/views/more_screen.dart';

import '../../../core/services/notification_service.dart';

bool isModalOpen = false;

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({Key? key}) : super(key: key);

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  final CartController cartController = Get.find<CartController>();

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.initialize(context);
    });
  }

  Future<bool> onWillPop() async {
    if (isModalOpen) {
      isModalOpen = false;

      return true;
    }

    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Get.snackbar("Exit", "Tap again to exit");

      return false;
    }

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> items = [
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.home_fill),
        title: "Home",
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.clipboard_fill),
        title: "Bookings",
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: Obx(
          () => cartController.fetch.value == true &&
                  cartController.cartDetailsDataModel.value.status == 400
              ? const Icon(Remix.shopping_cart_2_fill)
              : badges.Badge(
                  position: badges.BadgePosition.topEnd(
                    top: -2,
                    end: -5,
                  ),
                  showBadge: cartController.cartDetailsDataModel.value.messages
                          ?.status?.allCart !=
                      null,
                  badgeContent: Text(
                    cartController.cartDetailsDataModel.value.messages?.status
                            ?.allCart?.length
                            .toString() ??
                        "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  child: const Icon(
                    Remix.shopping_cart_2_fill,
                  ),
                ),
        ),
        title: "Cart",
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.more_2_line),
        title: "More",
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
    ];

    List<Widget> screens = const [
      DashboardScreen(),
      OrderScreen(),
      CartScreen(),
      MoreScreen(),
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: screens,
        items: items,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        navBarStyle: NavBarStyle.style8,
      ),
    );
  }
}
