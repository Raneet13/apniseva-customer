import 'dart:io';

import 'package:apniseva/screens/dashboard/screens/dashboard_screen.dart';
import 'package:apniseva/screens/more/screens/more_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:remixicon/remixicon.dart';
import 'package:badges/badges.dart' as badges;
import '../controller/cart_controller/cart_controller.dart';
import '../main.dart';
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
    // TODO: implement initState
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
        // print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          // print("New Notification");
          // print(message.data['_id']);
          if (message.data['_id'] != null) {
            LocalNotificationService.initialize();
            LocalNotificationService.createanddisplaynotification(message);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => NavigateScreen(
            //       id: message.data['_id'].toString() ?? "",
            //     ),
            //   ),
            // );
          } else
            LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(
      //     "This messssage iis not come to you r phone beacase of the notificatio nt allow by th user");

      if (message.notification != null) {
        // print('Message also contained a notification: ${message.notification}');
        LocalNotificationService.initialize();
        // if (kIsWeb) {
        //   ShowToast(msg: "Notification is error  is come");
        // } else {
        LocalNotificationService.createanddisplaynotification(message);
        print(
            "title:${message.notification!.title}, message: ${message.notification!.body}");
        // if (message.notification!.title == "Booking Start") {
        //   Provider.of<BookingtaxiViewmodel>(context, listen: false)
        //       .serachDriverCustomer(context);
        // }
        // //
        // if (message.notification!.title == "Booking Complete") {
        //   // Provider.of<BookingtaxiViewmodel>(context, listen: false)
        //   //     .findDriver(bookingId: "134");
        //   Provider.of<TabViewmodel>(context, listen: true)
        //               .tabController
        //               .index ==
        //           2
        //       ? context.push('/home/thankyouScreen', extra: {'id': '0'})
        //       : context.push('/home/sucessRide', extra: {'id': '0'});
        // }
        // // ShowToast(msg: "Notification is come");
        // print(
        //     "This messssage iis not come to you r phone beacase of the notificatio nt allow by th user");
        // }
        // context.go('/home/conformBooking', extra: {'id': '0'});
        // Provider.of<BookingtaxiViewmodel>(context, listen: false)
        //     .serachDriverCustomer(context);
        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        //   if (mounted) {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           title: Text("Notification"),
        //           content: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text("This is your notification"),
        //               Text("${message.notification!.title}"),
        //               Text("Message: ${message.notification!.body}"),
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   }
        // });

        // });
      } else {
        print(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("yu click the notification");
    });
    // FirebaseMessaging.onMessage.listen(
    //   (message) async {
    //     print("FirebaseMessaging.onMessage.listen");

    //     final noti = message.notification;
    //     final androidChannel = LocalNotificationService.androidChannel;
    //     if (noti != null) {
    //       print(noti.title);
    //       print(noti.body);

    //       print("message.data11 ${message.data}");
    //       showOverlayNotification(
    //           (context) => Text("This is your notification"));
    //       // showSimpleNotification(Text(noti.title.toString()),
    //       //     subtitle: Text(noti.body.toString()),
    //       //     duration: Duration(seconds: 5));
    //       // LocalNotificationService.notificationsPlugin.show(
    //       //     noti.hashCode,
    //       //     noti.title,
    //       //     noti.body,
    //       //     NotificationDetails(
    //       //         android: AndroidNotificationDetails(
    //       //       androidChannel.id, androidChannel.name,
    //       //       channelDescription: androidChannel.description,
    //       //       // icon: '@drawable/launcher_icon.png'
    //       //     )),
    //       //     payload: jsonEncode(message.toMap()));
    //       // LocalNotificationService.initialize(context, message);
    //       // LocalNotificationService.createanddisplaynotification(message);
    //     }
    //   },
    // );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          // print(message.notification!.title);
          // print(message.notification!.body);
          // print("message.data22 ${message.data['_id']}");
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
