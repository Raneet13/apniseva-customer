import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../app/theme/app_colors.dart';

import '../controller/auth_controller.dart';
import '../widgets/auth_strings.dart';

import '../../../../shared/widgets/buttons/primary_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController authController = Get.find<AuthController>();

  Timer? _timer;

  int _start = 60;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  AssetPaths.logo,
                  height: 100,
                ),
                SizedBox(height: height * 0.05),
                Text(
                  AuthString.otpVerification,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${AuthString.enterOTP} ${authController.mobileController.text}",
                ),
                SizedBox(height: height * 0.05),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: authController.otpController,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    activeColor: AppColors.primary,
                  ),
                  onChanged: (_) {},
                ),
                SizedBox(height: height * 0.04),
                Text(
                  _start > 0
                      ? "00:${_start.toString().padLeft(2, '0')}"
                      : "Code Expired",
                ),
                SizedBox(height: height * 0.04),
                Obx(() {
                  return PrimaryButton(
                    text: AuthString.submit,
                    isLoading: authController.isLoading.value,
                    onPressed: authController.verifyOtp,
                  );
                }),
                const Spacer(),
                TextButton(
                  onPressed: _start == 0
                      ? () {
                          authController.sendOtp();

                          setState(() {
                            _start = 60;
                          });

                          startTimer();
                        }
                      : null,
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: Get.back,
                  child: const Text(
                    "Edit Mobile Number",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
