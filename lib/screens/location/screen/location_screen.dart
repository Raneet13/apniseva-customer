//lib/screens/location/screen/location_screen.dart
import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/controller/auth_controller.dart';
import '../../../features/dashboard/controller/dash_controller.dart';
import '../lcontroller/location_controller.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../../utils/buttons.dart';

class MainLocationScreen extends StatefulWidget {
  const MainLocationScreen({Key? key}) : super(key: key);

  @override
  State<MainLocationScreen> createState() => _MainLocationScreenState();
}

class _MainLocationScreenState extends State<MainLocationScreen> {
  DateTime lastTimeBackButtonWasClicked = DateTime.now();
  String? getLocation;

  final locController = Get.put(LocationController());
  final dashController = Get.put(DashController());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();

    // ✅ Correct updated check using citiesList
    if (locController.citiesList.isEmpty) {
      locController.getLoc();
    }
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      getLocation = prefs.getString(ApiStrings.cityName);
      debugPrint("Loaded saved location: $getLocation");
    });
  }

  checkLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cityID = preferences.getString(ApiStrings.cityID);
    if (cityID == null) {
      Get.snackbar('Location', 'Choose your Location');
    } else {
      // ✅ Proceed to dashboard
      Get.offAll(() => const BottomNavBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (locController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 3),
                SizedBox(height: 16),
                Text("Loading locations..."),
              ],
            ),
          );
        }

        // If no cities loaded
        if (locController.citiesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No cities found"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: locController.getLoc,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        // ✅ Main UI - Location Picker
        return Center(
          child: Card(
            elevation: 12,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Location",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: getLocation,
                        hint: const Text("Select your city"),
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: locController.citiesList.map((city) {
                          return DropdownMenuItem(
                            value: city.cityName,
                            child: Text(city.cityName ?? ""),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() => getLocation = value);

                          final selected = locController.citiesList
                              .firstWhere((c) => c.cityName == value);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString(
                              ApiStrings.cityID, selected.cityId ?? "");
                          await prefs.setString(
                              ApiStrings.cityName, selected.cityName ?? "");
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  PrimaryButton(
                    width: double.infinity,
                    height: 50,
                    onPressed: () {
                      if (getLocation == null) {
                        Get.snackbar("Error", "Please select a location");
                      } else {
                        dashController.getDashboard();
                        checkLocation();
                      }
                    },
                    child: const Text("SAVE",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
