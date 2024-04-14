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
      String? userID = preferences.getString(ApiStrings.userID);
      String? cityID = preferences.getString(ApiStrings.cityID);
      String? categoryID = preferences.getString(ApiStrings.catID);

      String? serviceAPI = ApiEndPoint.service;

      Map<String, String> body = {
        'user_id': userID!,
        'city_id': cityID!,
        'category_id': categoryID!
      };

      Map<String, String> headers = {
        'Content-Type': "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(serviceAPI),
          body: jsonEncode(body), headers: headers);
      serviceModel = serviceDataModelFromJson(response.body);

      if (response.statusCode == 200 && serviceModel.status == 200) {
        serviceDataModel.value = serviceModel;
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
