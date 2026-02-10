//lib/features/dashboard/controller/dash_controller.dart
import 'dart:convert';
import 'package:apniseva/core/constants/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dash_model.dart';
import '../../../utils/api_endpoint_strings/api_endpoint_strings.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../../screens/auth/controller/auth_controller.dart';
import 'package:apniseva/core/constants/storage_keys.dart';

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

      String? cityID = prefs.getString(StorageKeys.cityId);
      String? userID = prefs.getString(StorageKeys.userId);

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
        Uri.parse(ApiEndpoints.dashboard),
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint(
          'Dashboard API Status Code: ${ApiEndpoints.dashboard} - ${response.statusCode}');

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
