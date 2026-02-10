//location_controller.dart
import 'dart:convert';

import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/location_model/location_model.dart';
// location_controller.dart

class LocationController extends GetxController {
  RxBool isLoading = false.obs;

  // Better approach - Store cities directly
  RxList<City> citiesList = <City>[].obs;

  Future<void> getLoc() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? id = pref.getBool('isGuest') ?? false
          ? ApiStrings.guestUserID
          : pref.getString(ApiStrings.userID);

      final response = await http.post(
        Uri.parse("${ApiEndPoint.getLoc}=$id"),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        LocationModel model = locationModelFromJson(response.body);

        // ✅ Extract cities safely
        final cities = model.messages?.status?.city ?? [];

        citiesList.assignAll(cities); // ← Very important

        debugPrint("✅ Loaded ${cities.length} cities");
      } else {
        debugPrint("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      Get.snackbar("Error", "Failed to load cities");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
