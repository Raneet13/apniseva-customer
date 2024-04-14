import 'dart:io';

import 'package:apniseva/screens/dashboard/screens/dashboard_screen.dart';
import 'package:apniseva/screens/more/screens/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:remixicon/remixicon.dart';
import 'package:badges/badges.dart' as badges;
import '../controller/cart_controller/cart_controller.dart';
import '../main.dart';
import '../screens/cart/screen/cart_screen.dart';
import '../screens/orders/screens/order_screen.dart';
import 'color.dart';

bool isModalOpen = false;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  DateTime lastTimeBackButtonWasClicked = DateTime.now();
  final cartController = Get.put(CartController());
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    if (isModalOpen) {
      isModalOpen = false;
      return Future.value(true);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Get.snackbar("Exit", "Tap again to exit");
        return Future.value(false);
      }
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> item = [
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.home_fill),
        title: ("Home"),
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.clipboard_fill),
        iconSize: 22,
        title: ('Bookings'),
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: Obx(
          () => cartController.fetch.value == true &&
                  cartController.cartDetailsDataModel.value.status == 400
              ? Icon(Remix.shopping_cart_2_fill)
              : badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -5, end: -5),
                  showBadge: cartController.cartDetailsDataModel.value.messages
                              ?.status!.allCart! ==
                          null
                      ? false
                      : true,
                  badgeContent: Text(
                    cartController.cartDetailsDataModel.value.messages?.status!
                                .allCart! ==
                            null
                        ? ''
                        : cartController.cartDetailsDataModel.value.messages!
                            .status!.allCart!.length
                            .toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  child: const Icon(Remix.shopping_cart_2_fill)),
        ),
        iconSize: 22,
        title: ('Cart'),
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.more_2_line),
        iconSize: 22,
        title: ('More'),
        textStyle: Theme.of(context).textTheme.titleMedium,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
    ];

    List<Widget> screens = const [
      DashScreen(),
      BookingScreen(),
      CartScreen(),
      MoreScreen()
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: PersistentTabView(
        context,
        /*onWillPop: (context) async{
          await showDialog(
            context: context!,
            useSafeArea: true,
            builder: (final context) => Container(
              height: 50,
              width: 50,
              color: Colors.white,
              child: ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                  },
            ),
          ),
          );
          return true;
        },*/
        selectedTabScreenContext: (final context) {
          testContext = context;
        },
        controller: _controller,
        screens: screens,
        items: item,
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style8,
      ),
    );
  }
}
