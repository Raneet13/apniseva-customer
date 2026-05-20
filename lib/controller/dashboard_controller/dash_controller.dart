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
    isLoading.value = true;
    DashDataModel dashModel = DashDataModel();

    SharedPreferences pref = await SharedPreferences.getInstance();
    // Default to empty string or "0" if null to avoid "Null check operator used on a null value"
    String cityID = pref.getString(ApiStrings.cityID) ?? "";
    String userID = pref.getString(ApiStrings.userID) ?? "0";

    debugPrint("UserID: $userID");
    debugPrint("CityID: $cityID");

    if (cityID.isEmpty) {
      isLoading.value = false;
      return false;
    }

    String dashApi = ApiEndPoint.getDash;

    Map<String, String> body = {"user_id": userID, "city_id": cityID};
    Map<String, String> header = {
      "Content-Type": "application/json; charset=utf-8"
    };

    try {
      http.Response response = await http.post(Uri.parse(dashApi),
          body: jsonEncode(body), headers: header);
      debugPrint('DashAPI Status Code: ${response.statusCode.toString()}');
      
      if (response.statusCode == 200) {
        dashModel = dashDataModelFromJson(response.body);
        if (dashModel.status == 200) {
          dashDataModel.value = dashModel;
        }
      }
    } catch (e) {
      debugPrint("Error fetching dashboard: $e");
    }
    
    isLoading.value = false;
    return true;
  }
}
