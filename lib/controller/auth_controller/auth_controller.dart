//auth_controller.dart
import 'dart:convert';

import 'package:apniseva/model/auth_model/user_data_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/auth/screens/otp_screen.dart';
import '../../utils/api_endpoint_strings/api_endpoint_strings.dart';
import '../../utils/api_strings/api_strings.dart';

class AuthController extends GetxController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  RxBool isLoading = false.obs;
  Rx<UserDataModel> userModel = UserDataModel().obs;
  String deviceTokenToSendPushNotification = "";
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    print("Your Toke Value is : ${token}");
    deviceTokenToSendPushNotification = token.toString();
  }

  loginWithOTP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobileNumber = pref.getString(ApiStrings.mobile);
    debugPrint(mobileNumber);
    isLoading.value = true;

    Map<String, String> body = {'contact': mobileNumber!};
    Map<String, String> header = {"Content-Type": "application/json"};

    http.Response response = await http.post(
      Uri.parse(ApiEndPoint.loginOtp),
      headers: header,
      body: jsonEncode(body),
    );
    Map data = jsonDecode(response.body);
    debugPrint('OtpAPI Status Code: ${response.statusCode}');
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      isLoading.value = false;
      pref.setString(ApiStrings.mobile,
          data['messages']["status"]["contact_otp"].toString());

      pref.setString(
          ApiStrings.otp, data['messages']["status"]["login_otp"].toString());

      String? otp = pref.getString(ApiStrings.otp);
      debugPrint("OTP during api: ${otp.toString()}");
      Get.to(() => OtpVerificationScreen(phoneNumber: mobileController.text));
    } else {
      isLoading.value = false;
      Get.snackbar('OTP', 'Something went wrong.');
    }
    otpController.clear();
  }

// auth_controller.dart
  Future<bool> getUserData() async {
    isLoading.value = true;
    UserDataModel model = UserDataModel();

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? mobile = pref.getString(ApiStrings.mobile);

      // ✅ Handle case where mobile is null
      if (mobile == null) {
        isLoading.value = false;
        return false;
      }

      String verifyOtp = ApiEndPoint.verifyOtp;

      Map<String, String> header = {
        'Content-type': 'application/json',
      };
      Map<String, String> body = {'contact': mobile};

      http.Response response = await http.post(
        Uri.parse(verifyOtp),
        body: jsonEncode(body),
        headers: header,
      );

      model = userDataModelFromJson(response.body);

      if (response.statusCode == 200 && model.status == 200) {
        // ✅ Safe null checks for userId
        final userId = model.messages?.status?.userId;
        if (userId != null) {
          pref.setString(ApiStrings.userID, userId);
          debugPrint("User Id $userId");
        }
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error in getUserData: $e");
      return false;
    }
  }

  clear() {
    mobileController.clear();
    otpController.clear();
  }

  Future<bool> isGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest') ?? false;
  }

  Future<bool> updateUserData(
    String name,
    String email,
    String phoneNumber,
  ) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    Map<String, String> body = {
      'user_id': '${userModel.value.messages!.status!.userId}',
      'full_name': name,
      'e_mail': email,
      'contact_number': phoneNumber,
    };

    http.Response response = await http.post(
        Uri.parse('https://apniseva.com/API/update_profile'),
        body: jsonEncode(body),
        headers: header);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
