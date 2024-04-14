import 'dart:convert';

import 'package:apniseva/model/auth_model/user_data_model.dart';
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

  getUserData() async {
    isLoading.value = true;
    UserDataModel model = UserDataModel();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobile = pref.getString(ApiStrings.mobile)!;
    String verifyOtp = ApiEndPoint.verifyOtp;

    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    Map<String, String> body = {'contact': mobile};
    debugPrint('UserDataApi: $verifyOtp');

    http.Response response = await http.post(Uri.parse(verifyOtp),
        body: jsonEncode(body), headers: header);
    // debugPrint("GetUserResponse: ${response.body}");
    model = userDataModelFromJson(response.body);

    if (response.statusCode == 200 && model.status == 200) {
      userModel.value = model;
      pref.setString(
          ApiStrings.userID, userModel.value.messages!.status!.userId!);
      String? userID = pref.getString(ApiStrings.userID);
      debugPrint("User Id ${userModel.value.messages!.status!.userId!}");
      isLoading.value = false;
      return true;
    }
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
