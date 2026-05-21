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
    if (mobileNumber == null) return;
    
    isLoading.value = true;

    Map<String, String> body = {'contact': mobileNumber};
    Map<String, String> header = {"Content-Type": "application/json"};

    try {
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
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error in loginWithOTP: $e");
    }
    otpController.clear();
  }

  getUserData() async {
    isLoading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobile = pref.getString(ApiStrings.mobile);
    
    if (mobile == null) {
      isLoading.value = false;
      return;
    }
    
    String verifyOtp = ApiEndPoint.verifyOtp;

    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    Map<String, String> body = {'contact': mobile};
    debugPrint('UserDataApi: $verifyOtp');

    try {
      http.Response response = await http.post(Uri.parse(verifyOtp),
          body: jsonEncode(body), headers: header);
      
      UserDataModel model = userDataModelFromJson(response.body);

      if (response.statusCode == 200 && model.status == 200) {
        userModel.value = model;
        if (userModel.value.messages?.status?.userId != null) {
          pref.setString(
              ApiStrings.userID, userModel.value.messages!.status!.userId!);
          debugPrint("User Id ${userModel.value.messages!.status!.userId!}");
        }
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      debugPrint("Error in getUserData: $e");
    }
    isLoading.value = false;
    return false;
  }

  clear() {
    mobileController.clear();
    otpController.clear();
  }

  Future<bool> updateUserData(
    String name,
    String email,
    String phoneNumber,
  ) async {
    String? userId = userModel.value.messages?.status?.userId;
    if (userId == null) {
      debugPrint("Update Profile Failed: User ID is null");
      return false;
    }

    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    Map<String, String> body = {
      'user_id': userId,
      'full_name': name,
      'e_mail': email,
      'contact_number': phoneNumber,
    };

    try {
      debugPrint("Updating Profile at: ${ApiEndPoint.updateProfile}");
      debugPrint("Body: ${jsonEncode(body)}");
      
      http.Response response = await http.post(
          Uri.parse(ApiEndPoint.updateProfile),
          body: jsonEncode(body),
          headers: header);

      debugPrint("Update Profile Status: ${response.statusCode}");
      debugPrint("Update Profile Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if the API returned a success status in the body
        if (data['status'] == 200 || data['error'] == false) {
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error in updateUserData: $e");
    }
    return false;
  }
}
