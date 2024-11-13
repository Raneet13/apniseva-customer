import 'package:apniseva/controller/auth_controller/auth_controller.dart';
import 'package:apniseva/screens/notification/localNotification.dart';
import 'package:apniseva/screens/splash_screen/widgets/spalsh_string.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_strings/api_strings.dart';
import '../../../utils/theme.dart';
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
    // TODO: implement initState
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
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Image.asset(SplashStrings.apniSevaLogo),
              ),
              SizedBox(height: height * 0.10),
              Text(AuthString.getStarted,
                  style: AppTheme.lightTheme.textTheme.headlineLarge),
              SizedBox(
                width: width * 0.65,
                child: Text(AuthString.enterMobileNo,
                    style: AppTheme.lightTheme.textTheme.titleLarge),
              ),
              SizedBox(height: height * 0.015),
              Form(
                  key: _regdKey,
                  child: PhoneNumberVerification(
                    controller: authController.mobileController,
                  )),
              SizedBox(height: height * 0.02),
              PrimaryButton(
                width: width,
                height: 47,
                onPressed: () async {
                  if (authController.mobileController.text.isEmpty) {
                    errorLabel = AuthString.noNumberProvided;
                    Get.snackbar('Login Error', errorLabel!);
                  } else if (authController.mobileController.text
                          .trim()
                          .length !=
                      10) {
                    errorLabel = AuthString.validation;
                    Get.snackbar('Login Error', errorLabel!);
                  } else if (_regdKey.currentState!.validate()) {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString(ApiStrings.mobile,
                        authController.mobileController.text);

                    Future.delayed(Duration.zero, () {
                      authController.loginWithOTP();
                    });
                  } else {
                    Get.snackbar('Login Error', errorLabel!);
                  }
                },
                child: Obx(() {
                  return authController.isLoading.value == true
                      ? SizedBox(
                          width: width,
                          height: 47,
                          child: const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          AuthString.getOTP,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600),
                        );
                }),
              ),
              const Spacer(),
            ]),
          ),
        ),
      ),
    );
  }
}
