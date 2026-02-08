// otp_screen.dart
import 'dart:async';

import 'package:apniseva/controller/location_controller/location_controller.dart';
import 'package:apniseva/screens/location/screen/location_screen.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller/auth_controller.dart';
import '../../../utils/color.dart';

import 'package:get/get.dart';

import '../../splash_screen/widgets/spalsh_string.dart';
import '../widget/auth_strings.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final authController = Get.put(AuthController());
  final locController = Get.put(LocationController());

  Timer? _timer;
  int _start = 60;

  @override
  void dispose() {
    _timer?.cancel();
    // authController.otpController.dispose();
    authController.mobileController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    // Use addPostFrameCallback for operations that depend on context or need to run after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getUserData();
    });
    super.initState();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  verifyOTP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? otp = preferences.getString(ApiStrings.otp);
    String? cityID = preferences.getString(ApiStrings.cityID);

    if (authController.otpController.text != otp &&
        authController.otpController.text != "123456") {
      // Added 123456 for testing if needed, or remove if strict
      // Original logic was just otp check. Sticking to original logic strictly:
      if (otp != authController.otpController.text.toString()) {
        Get.snackbar("OTP", "Incorrect OTP",
            backgroundColor: Colors.red[50], colorText: Colors.red);
        return;
      }
    }

    // Check again to be sure if I shouldn't rely on "123456" comment above.
    // Original Code: if (otp != authController.otpController.text.toString()) { Get.snackbar ... }
    if (otp != authController.otpController.text.toString()) {
      Get.snackbar("OTP", "Incorrect OTP",
          backgroundColor: Colors.red[50], colorText: Colors.red);
      return;
    }
    // ✅ If OTP is correct, clear guest status
    if (authController.otpController.text == otp) {
      await preferences.setBool('isGuest', false); // 🔑 Clear guest flag
      // ... rest of your navigation logic ...
    }
    if (cityID == null) {
      Get.to(() => const MainLocationScreen());
    } else if (authController.userModel.value.messages?.status?.isLoggedIn ==
        true) {
      Get.to(() => const BottomNavBar());
    } else {
      // Logic for else case (maybe stay or go somewhere else?)
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height:
                height - MediaQuery.of(context).padding.top - kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    SplashStrings.apniSevaLogo,
                    height: 100,
                  ),
                ),
                SizedBox(height: height * 0.05),
                Text(
                  AuthString.otpVerification,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '${AuthString.enterOTP} ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    children: [
                      TextSpan(
                        text: '+91-${widget.phoneNumber}',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),

                // Pin Code Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: authController.otpController,
                    autoDisposeControllers: false,
                    animationType: AnimationType.fade,
                    cursorColor: primaryColor,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.grey[50], // subtle background
                      selectedFillColor: Colors.white,
                      activeColor: primaryColor,
                      inactiveColor: Colors.grey[300],
                      selectedColor: primaryColor,
                      borderWidth: 1.5,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),

                SizedBox(height: height * 0.04),

                // Timer
                if (_start > 0)
                  Text(
                    "00:${_start.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[400],
                    ),
                  )
                else
                  Text(
                    "Code Expired",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold),
                  ),

                SizedBox(height: height * 0.04),

                // Submit Button
                PrimaryButton(
                  width: width,
                  height: 52,
                  onPressed: () {
                    verifyOTP();
                  },
                  child: Text(
                    AuthString.submit,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Resend & Edit
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_start == 0) {
                          authController.otpController.clear();
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          // String? mobile = preferences.getString(ApiStrings.mobile); // Unused
                          setState(() {
                            _start = 60;
                            startTimer();
                          });
                          Future.delayed(Duration.zero, () {
                            authController.loginWithOTP();
                          });
                        } else {
                          Get.snackbar(
                              "Wait", "Please wait for timer to finish",
                              backgroundColor: Colors.orange[50],
                              colorText: Colors.orange);
                        }
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: _start == 0 ? primaryColor : Colors.grey,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                    ),
                    child: const Text('Edit Mobile Number',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500))),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
