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

  late final AuthController authController;
  String? errorLabel;

  @override
  void initState() {
    super.initState();

    // 1. Prevent duplicate controller creation
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    authController = Get.find<AuthController>();

    // 2. Clear old snackbars to prevent queued errors
    Get.closeCurrentSnackbar();

    // 3. Initialize safely
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        LocalNotificationService.initNoti();
        // Call notification logic (ensure controller handles error internally)
        await authController.getDeviceTokenToSendNotification();
      } catch (e) {
        debugPrint("Notification Init Error: $e");
      }
    });
  }

  @override
  void dispose() {
    // Only dispose controllers if they were created specifically for this screen
    // and not globally. Since we used Get.put above, be careful.
    // If mobileController is global, don't dispose it here.
    super.dispose();
  }

  // Helper to prevent Opacity crash
  double _safeOpacity(double val) {
    if (val.isNaN || val.isInfinite) return 0.0;
    return val.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final now = DateTime.now();
        if (now.difference(lastTimeBackButtonWasClicked) >=
            const Duration(seconds: 1)) {
          Get.closeCurrentSnackbar();
          Get.snackbar(
            'Exit App',
            "Press back button again to exit",
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
          );
          lastTimeBackButtonWasClicked = now;
        } else {
          // Force exit or navigate back
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                // Top Header
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
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo Animation - FIX APPLIED HERE
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 800),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity:
                                        _safeOpacity(value), // Safe Opacity
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
                              const SizedBox(height: 40),
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
                      // Safe Opacity applied here too
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child:
                            Opacity(opacity: _safeOpacity(value), child: child),
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
                              borderRadius: 12,
                              onPressed: () async {
                                if (authController
                                    .mobileController.text.isEmpty) {
                                  errorLabel = AuthString.noNumberProvided;
                                } else if (authController.mobileController.text
                                        .trim()
                                        .length !=
                                    10) {
                                  errorLabel = AuthString.validation;
                                } else if (_regdKey.currentState!.validate()) {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setString(ApiStrings.mobile,
                                      authController.mobileController.text);
                                  authController.loginWithOTP();
                                  return;
                                }

                                // Show error snackbar only if logic failed above
                                if (errorLabel != null) {
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
                            const SizedBox(height: 25),
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
                            const SizedBox(height: 25),
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isGuest', true);
                                  String? cityID =
                                      prefs.getString(ApiStrings.cityID);

                                  if (cityID == null) {
                                    Get.offAll(
                                        () => const MainLocationScreen());
                                  } else {
                                    Get.offAll(() => const BottomNavBar());
                                  }
                                },
                                child: Text(
                                  AuthString.guestUserButtonTitle,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
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
