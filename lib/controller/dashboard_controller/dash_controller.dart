/*
import 'dart:convert';

import 'package:apniseva/model/dashboard_model/dash_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<DashDataModel> dashDataModel = DashDataModel().obs;

  getDashboard() async {
    // try{
    isLoading.value = true;
    DashDataModel dashModel = DashDataModel();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? cityID = pref.getString(ApiStrings.cityID);
    String? userID = pref.getString(ApiStrings.userID);
    debugPrint("Dashboard User ID: $userID");
    print(userID);
    print(cityID);
    String? dashApi = ApiEndPoint.getDash;

    Map<String, String> body = {"user_id": userID!, "city_id": cityID!};
    Map<String, String> header = {
      "Content-Type": "application/json; charset=utf-8"
    };

    http.Response response = await http.post(Uri.parse(dashApi),
        body: jsonEncode(body), headers: header);
    debugPrint('DashAPI Status Code: ${response.statusCode.toString()}');
    dashModel = dashDataModelFromJson(response.body);
    // debugPrint(response.body);

    if (response.statusCode == 200 && dashModel.status == 200) {
      dashDataModel.value = dashModel;
    }
    isLoading.value = false;
    return true;
    // }

    /*catch(error) {
     isLoading.value = false;
     Get.snackbar("Dashboard", "Something went wrong! please try again later",
         colorText: Colors.black,
         backgroundColor: Colors.white54
     );
     debugPrint(error.toString());
     return false;
   }*/
  }
}
*/
// dashboard_controller/dash_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/dashboard_model/dash_model.dart';
import '../../utils/api_endpoint_strings/api_endpoint_strings.dart';
import '../../utils/api_strings/api_strings.dart';
import '../auth_controller/auth_controller.dart';

class DashController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<DashDataModel> dashDataModel = DashDataModel().obs;

  final AuthController _authController = Get.find();

  Future<void> getDashboard() async {
    isLoading.value = true;

    try {
      // ✅ Check if guest user
      final bool isGuest = await _authController.isGuestUser();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? cityID = prefs.getString(ApiStrings.cityID);
      String? userID = prefs.getString(ApiStrings.userID);

      // ✅ Prepare body conditionally
      Map<String, String> body = {
        'city_id': cityID ?? '', // Handle null safely
      };

      // Only add user_id if NOT guest
      if (!isGuest) {
        body['user_id'] = userID ?? '';
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      http.Response response = await http.post(
        Uri.parse(ApiEndPoint.getDash),
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint(
          'Dashboard API Status Code: ${ApiEndPoint.getDash} - ${response.statusCode}');

      if (response.statusCode == 200) {
        dashDataModel.value = dashDataModelFromJson(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load dashboard data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
