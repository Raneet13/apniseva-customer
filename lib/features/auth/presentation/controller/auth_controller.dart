import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/storage_keys.dart';

import '../views/otp_screen.dart';

class AuthController extends GetxController {
  final AuthRepository repo;

  final StorageService storage;

  AuthController(
    this.repo,
    this.storage,
  );

  final mobileController = TextEditingController();

  final otpController = TextEditingController();

  final isLoading = false.obs;

  Future<void> sendOtp() async {
    try {
      isLoading.value = true;

      final result = await repo.loginWithOtp(
        mobileController.text,
      );

      await storage.prefs.setString(
        StorageKeys.mobile,
        mobileController.text,
      );

      Get.to(() => OtpScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;

      final result = await repo.verifyUser(
        mobileController.text,
      );

      final status = result["messages"]["status"];

      final userId = status["user_id"];

      final isLoggedIn = status["is_logged_in"];

      await storage.setUserId(userId);

      await storage.prefs.setBool("isGuest", false);

      final cityId = storage.prefs.getString("loc_id");

      if (cityId == null) {
        Get.offAllNamed("/location");
      } else {
        Get.offAllNamed("/dashboard");
      }
    } catch (e) {
      Get.snackbar(
        "OTP",
        "Invalid OTP",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> continueAsGuest() async {
    await storage.prefs.setBool("isGuest", true);

    Get.offAllNamed("/dashboard");
  }
}
