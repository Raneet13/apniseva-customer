import 'dart:io';

import 'package:apniseva/screens/dashboard/screens/dashboard_screen.dart';
import 'package:apniseva/screens/more/screens/more_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:remixicon/remixicon.dart';
import 'package:badges/badges.dart' as badges;
import '../controller/cart_controller/cart_controller.dart';
import '../screens/cart/screen/cart_screen.dart';
import '../screens/notification/localNotification.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationInit(context);
    });
  }

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

  Future<void> backgroundHandler(RemoteMessage message) async {
    LocalNotificationService.initialize();
    LocalNotificationService.createanddisplaynotification(message);
  }

  notificationInit(BuildContext context) async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.data['_id'] != null) {
            LocalNotificationService.initialize();
            LocalNotificationService.createanddisplaynotification(message);
          } else {
            LocalNotificationService.createanddisplaynotification(message);
          }
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService.initialize();
        LocalNotificationService.createanddisplaynotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("you clicked the notification");
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
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
          () {
            bool hasCartItems = cartController.cartDetailsDataModel.value.messages?.status?.allCart != null &&
                cartController.cartDetailsDataModel.value.messages!.status!.allCart!.isNotEmpty;
            
            int cartCount = hasCartItems ? cartController.cartDetailsDataModel.value.messages!.status!.allCart!.length : 0;

            if (cartController.fetch.value == true &&
                cartController.cartDetailsDataModel.value.status == 400) {
              return const Icon(Remix.shopping_cart_2_fill);
            }

            return badges.Badge(
                position: badges.BadgePosition.topEnd(top: -2, end: -5),
                showBadge: hasCartItems,
                badgeContent: Text(
                  cartCount > 0 ? cartCount.toString() : '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                child: const Icon(Remix.shopping_cart_2_fill));
          },
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
        controller: _controller,
        screens: screens,
        items: item,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        navBarStyle: NavBarStyle.style8,
      ),
    );
  }
}
