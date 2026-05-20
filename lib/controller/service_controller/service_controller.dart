import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apniseva/model/service_model/service_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<ServiceDataModel> serviceDataModel = ServiceDataModel().obs;

  getService() async {
    try {
      isLoading.value = true;
      ServiceDataModel serviceModel = ServiceDataModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      
      // Use default values if null to support Guest mode
      String userID = preferences.getString(ApiStrings.userID) ?? "0";
      String cityID = preferences.getString(ApiStrings.cityID) ?? "0";
      String? categoryID = preferences.getString(ApiStrings.catID);

      if (categoryID == null) {
        isLoading.value = false;
        return;
      }

      String? serviceAPI = ApiEndPoint.service;

      Map<String, String> body = {
        'user_id': userID,
        'city_id': cityID,
        'category_id': categoryID
      };

      Map<String, String> headers = {
        'Content-Type': "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(serviceAPI),
          body: jsonEncode(body), headers: headers);
      
      if (response.statusCode == 200) {
        serviceModel = serviceDataModelFromJson(response.body);
        if (serviceModel.status == 200) {
          serviceDataModel.value = serviceModel;
        }
      }
      isLoading.value = false;
    } catch (e) {
      debugPrint("Error in getService: $e");
      isLoading.value = false;
    }
  }
}
