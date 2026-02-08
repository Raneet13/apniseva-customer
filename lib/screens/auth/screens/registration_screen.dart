// registration_screen.dart
import 'package:apniseva/controller/auth_controller/auth_controller.dart';
import 'package:apniseva/screens/location/screen/location_screen.dart';
import 'package:apniseva/screens/notification/localNotification.dart';
import 'package:apniseva/screens/splash_screen/widgets/spalsh_string.dart';
import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_strings/api_strings.dart';
import '../../../utils/color.dart';
import '../widget/auth_input_field.dart';
import '../widget/auth_strings.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  DateTime lastTimeBackButtonWasClicked = DateTime.now();
  final _regdKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  String? errorLabel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LocalNotificationService.initNoti();
      await authController.getDeviceTokenToSendNotification();
    });
  }

  @override
  void dispose() {
    authController.otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(lastTimeBackButtonWasClicked) >=
            const Duration(seconds: 1)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
              content: Text("Press the back button again to go back"),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
          lastTimeBackButtonWasClicked = DateTime.now();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
        body: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                // Top Blue Header Section with Curve
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * 0.45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative Circles
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),

                        // Logo Content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 800),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 5),
                                      )
                                    ],
                                  ),
                                  child: Image.asset(
                                    SplashStrings.apniSevaLogo,
                                    height: 65,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Please login to your account",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(
                                  height: 40), // Space for card overlap
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Card Section
                Positioned(
                  top: height * 0.38,
                  left: 20,
                  right: 20,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF152E88).withOpacity(0.15),
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _regdKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mobile Number",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Container to ensure consistent look for input
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                    color: Colors.grey.withOpacity(0.05)),
                                padding: const EdgeInsets.only(
                                    left: 10, right: 5, top: 2, bottom: 2),
                                child: PhoneNumberVerification(
                                  controller: authController.mobileController,
                                )),
                            const SizedBox(height: 25),
                            PrimaryButton(
                              width: double.infinity,
                              height: 54,
                              borderRadius: 12, // Increased border radiuss
                              onPressed: () async {
                                if (authController
                                    .mobileController.text.isEmpty) {
                                  errorLabel = AuthString.noNumberProvided;
                                  Get.snackbar('Login Error', errorLabel!,
                                      backgroundColor: Colors.red[50],
                                      colorText: Colors.red);
                                } else if (authController.mobileController.text
                                        .trim()
                                        .length !=
                                    10) {
                                  errorLabel = AuthString.validation;
                                  Get.snackbar('Login Error', errorLabel!,
                                      backgroundColor: Colors.red[50],
                                      colorText: Colors.red);
                                } else if (_regdKey.currentState!.validate()) {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setString(ApiStrings.mobile,
                                      authController.mobileController.text);

                                  Future.delayed(Duration.zero, () {
                                    authController.loginWithOTP();
                                  });
                                } else {
                                  Get.snackbar('Login Error', errorLabel!,
                                      backgroundColor: Colors.red[50],
                                      colorText: Colors.red);
                                }
                              },
                              child: Obx(() {
                                return authController.isLoading.value == true
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        AuthString.getOTP.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      );
                              }),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "----   OR   ----",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  // ✅ Set guest flag
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool(
                                      'isGuest', true); // Mark as guest

                                  // ✅ Check if city is selected
                                  String? cityID =
                                      prefs.getString(ApiStrings.cityID);

                                  if (cityID == null) {
                                    debugPrint(
                                        "!!!!!---- No city selected, navigating to location screen.");
                                    // No city selected → Go to city selection
                                    Get.offAll(
                                        () => const MainLocationScreen());
                                  } else {
                                    // City already selected → Go to dashboard
                                    Get.offAll(() => const BottomNavBar());
                                  }
                                },
                                child: Text(
                                  AuthString.guestUserButtonTitle,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    // ignore: deprecated_member_use
                                    color: primaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.75),

                // Footer
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "By continuing, you agree to our\nTerms & Conditions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[400],
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
