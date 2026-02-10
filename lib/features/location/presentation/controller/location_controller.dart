import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/api_endpoints.dart';

import '../../data/models/location_model.dart';

class LocationController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final StorageService storage = Get.find<StorageService>();

  RxBool isLoading = false.obs;

  RxList<City> citiesList = <City>[].obs;

  RxString selectedCity = "".obs;

  @override
  void onInit() {
    super.onInit();

    loadSavedCity();

    getLocations();
  }

  Future<void> loadSavedCity() async {
    selectedCity.value = storage.prefs.getString("city_name") ?? "";
  }

  Future<void> getLocations() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final userId =
          storage.prefs.getBool("isGuest") == true ? "0" : storage.userId;

      final response = await apiClient.post(
        "${ApiEndpoints.getLoc}=$userId",
      );

      if (response.statusCode == 200) {
        final model = locationModelFromJson(response.body);

        citiesList.assignAll(
          model.messages?.status?.city ?? [],
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load locations",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCity(City city) async {
    await storage.prefs.setString("loc_id", city.cityId ?? "");

    await storage.prefs.setString("city_name", city.cityName ?? "");

    selectedCity.value = city.cityName ?? "";
  }
}
