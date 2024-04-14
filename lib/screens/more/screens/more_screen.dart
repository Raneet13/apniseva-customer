import 'package:apniseva/screens/orders/screens/order_screen.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller/auth_controller.dart';
import '../../../utils/color.dart';
import '../../address/screen/address_screen.dart';
import '../../auth/screens/registration_screen.dart';
import '../../cart/screen/cart_screen.dart';
import '../../contact_us/screens/contact_us.dart';
import '../../page/data_deliton.dart';
import '../../page/privacy_policy_page.dart';
import '../../profile/profile_screen/profile_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final moreController = Get.put(AuthController());
  // final profileController = Get.find<DashController>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      moreController.getUserData();
    });

    super.initState();
  }

  List screens = const [
    CartScreen(),
    ProfileScreen(),
    AddressScreen(),
    BookingScreen(),
    CartScreen(),
    CartScreen(),
    CartScreen(),
    CartScreen(),
    CartScreen(),
  ];

  List<String> items = [
    'Notifications',
    'Profile',
    'Address',
    'Orders',
    'Terms & Conditions',
    'Privacy Policy',
    'FAQ',
    'Career',
    'Blog',
    'Contact Us',
    'Support & Help'
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.22,
                width: width,
                color: primaryColor,
                padding: const EdgeInsets.only(top: 10),
                child: Obx(() {
                  return moreController.isLoading.value == true
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // User Profile Name
                            const Padding(
                              padding: EdgeInsets.only(left: 30.0),
                              child: CircleAvatar(
                                radius: 40,
                                // backgroundImage: NetworkImage(DashStrings.serviceImg),
                                backgroundImage: AssetImage(
                                    'assets/images/appLauncherIcon.jpeg'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                moreController.userModel.value.messages!.status!
                                        .fullname ??
                                    " ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .fontSize),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                    "User ID: ${moreController.userModel.value.messages!.status!.userId!}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall)),
                          ],
                        );
                }),
              ),

              /*InkWell(
                onTap: () {
                  debugPrint(moreController.userModel.value.messages!.status!.fullname.toString());
                  debugPrint(moreController.userModel.value.messages!.status!.userId);
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide.none,
                        top: BorderSide.none,
                        right: BorderSide.none,
                        bottom:
                        BorderSide(color: Colors.grey),
                      )),
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Notifications',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),*/

              InkWell(
                onTap: () {
                  Get.to(() => const ProfileScreen());
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Profile',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const AddressScreen());
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Address',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const BookingScreen());
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Orders',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () async {
                  // final Uri url = Uri.parse('https://apniseva.com/Contact_Us');
                  // if (await canLaunchUrl(url)) {
                  //   await launchUrl(
                  //     url,
                  //     mode: LaunchMode.externalNonBrowserApplication,
                  //   );
                  // }
                  Get.to(() => const ContactUs());

                  //launchUrlString('https://apniseva.com/Contact_Us');
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        ' Contact Us',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const PrivacyPolicy());
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Privacy Policy',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () async {
                  Get.to(() => const DataDeletion());
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Support & Help',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Alert'),
                          titlePadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          titleTextStyle:
                              Theme.of(context).textTheme.headlineLarge,
                          children: [
                            Text(
                              'Do you want to logout?',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PrimaryButton(
                                  width: width * 0.30,
                                  height: 40,
                                  onPressed: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.clear();
                                    Get.deleteAll();
                                    Get.offAll(
                                        () => const RegistrationScreen());
                                  },
                                  child: const Text('Yes'),
                                ),
                                SecoundaryButton(
                                    width: width * 0.30,
                                    height: 40,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'No',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ))
                              ],
                            )
                          ],
                        );
                      });
                },
                child: Container(
                  width: width,
                  height: height * 0.083,
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          ' Log Out',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
