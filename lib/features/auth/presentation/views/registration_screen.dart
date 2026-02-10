//lib/features/auth/presentation/views/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/storage/storage_service.dart';

import '../controller/auth_controller.dart';
import '../widgets/auth_strings.dart';
import '../widgets/phone_input_field.dart';

import '../../../../shared/widgets/buttons/primary_button.dart';

import '../../../location/presentation/views/location_screen.dart';
import '../../../../shared/widgets/navigation/app_bottom_navbar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthController authController = Get.find<AuthController>();

  final StorageService storage = Get.find<StorageService>();

  DateTime lastTimeBackButtonWasClicked = DateTime.now();

  final _regdKey = GlobalKey<FormState>();

  String? errorLabel;

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
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
        backgroundColor: const Color(0xFFF8F9FA),
        body: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                /// HEADER
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * 0.45,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Image(
                              image: AssetImage(AssetPaths.logo),
                              height: 65,
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
                        ],
                      ),
                    ),
                  ),
                ),

                /// FORM CARD
                Positioned(
                  top: height * 0.38,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 30,
                        )
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
                            ),
                          ),

                          const SizedBox(height: 10),

                          PhoneInputField(
                            controller: authController.mobileController,
                          ),

                          const SizedBox(height: 25),

                          /// GET OTP BUTTON
                          Obx(() {
                            return PrimaryButton(
                              text: AuthString.getOTP,
                              isLoading: authController.isLoading.value,
                              onPressed: () async {
                                if (authController
                                    .mobileController.text.isEmpty) {
                                  Get.snackbar('Login Error',
                                      AuthString.noNumberProvided);

                                  return;
                                }

                                if (authController
                                        .mobileController.text.length !=
                                    10) {
                                  Get.snackbar(
                                      'Login Error', AuthString.validation);

                                  return;
                                }

                                await authController.sendOtp();
                              },
                            );
                          }),

                          const SizedBox(height: 25),

                          Center(
                            child: Text(
                              "---- OR ----",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// CONTINUE AS GUEST
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                await storage.prefs.setBool('isGuest', true);

                                final cityId =
                                    storage.prefs.getString('loc_id');

                                if (cityId == null) {
                                  Get.offAll(() => const LocationScreen());
                                } else {
                                  Get.offAll(() => const AppBottomNavBar());
                                }
                              },
                              child: Text(
                                AuthString.guestUserButtonTitle,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// FOOTER
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
