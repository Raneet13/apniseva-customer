import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/navigation/app_bottom_navbar.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

import '../controller/location_controller.dart';
import '../../../dashboard/presentation/controller/dashboard_controller.dart';

class LocationScreen extends GetView<LocationController> {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashController = Get.find<DashboardController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Center(
          child: Card(
            elevation: 12,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Location",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: controller.selectedCity.value.isEmpty
                        ? null
                        : controller.selectedCity.value,
                    hint: const Text("Select city"),
                    isExpanded: true,
                    items: controller.citiesList.map((city) {
                      return DropdownMenuItem(
                        value: city.cityName,
                        child: Text(
                          city.cityName ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final city = controller.citiesList.firstWhere(
                        (c) => c.cityName == value,
                      );

                      controller.selectCity(city);
                    },
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "SAVE",
                    onPressed: () {
                      dashController.getDashboard();

                      Get.offAll(
                        () => const AppBottomNavBar(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
