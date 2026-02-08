import 'dart:convert';
import 'package:apniseva/model/dashboard_model/subcategory_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<SubCategoryDataModel> subCategoryDataModel = SubCategoryDataModel().obs;

  Future<bool> getSubCat() async {
    try {
      isLoading.value = true;
      SubCategoryDataModel subCatModel = SubCategoryDataModel();

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? catID = preferences.getString(ApiStrings.catID);
      String? cityID = preferences.getString(ApiStrings.cityID);

      // Check if user is guest
      bool isGuest = preferences.getBool('isGuest') ?? true;
      String? userID =
          isGuest ? null : preferences.getString(ApiStrings.userID);

      // Validate required fields
      if (catID == null || catID.isEmpty || cityID == null || cityID.isEmpty) {
        Get.snackbar('Error', 'Category or City information missing');
        isLoading.value = false;
        return false;
      }

      String subCatAPI = ApiEndPoint.subCat;
      debugPrint(
          "!!!--- SubCategory API URL: $subCatAPI"); // Build request body conditionally
      Map<String, String> body = {
        'cat_id': catID,
        'city_id': cityID,
      };

      // Only add user_id if not a guest
      if (!isGuest && userID != null) {
        body['user_id'] = userID;
      }

      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(subCatAPI),
          body: jsonEncode(body), headers: header);

      if (response.statusCode == 200) {
        subCatModel = subCategoryDataModelFromJson(response.body);

        if (subCatModel.status == 200) {
          subCategoryDataModel.value = subCatModel;
          isLoading.value = false;
          return true;
        }
      }
      print(
          "!!! --- SubCategory API Response Body: ${response.body}"); // Debugging line
      isLoading.value = false;
      Get.snackbar('SubCategory', 'Failed to load subcategories');
      return false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('SubCategory', 'Something went wrong: $e');
      return false;
    }
  }
}
