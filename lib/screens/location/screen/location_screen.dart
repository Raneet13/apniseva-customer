import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller/auth_controller.dart';
import '../../../controller/dashboard_controller/dash_controller.dart';
import '../../../controller/location_controller/location_controller.dart';
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
    Future.delayed(Duration.zero, () {
      locController.getLoc();
    });
    super.initState();
  }

  checkLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cityID = preferences.getString(ApiStrings.cityID);
    if (cityID == null) {
      Get.snackbar('Location', 'Choose your Location');
    } else {
      Get.to(() => const BottomNavBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Obx(() {
          return Card(
            elevation: 10,
            child: Container(
              width: width * 0.85,
              height: 160,
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8.0)),
              child: locController.isLoading.value == true ||
                      locController.locationModel.value.status == 400
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 2.5,
                      ),
                    ))
                  : Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose Location',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Container(
                          height: 47,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text('Choose your Location'),
                              value: getLocation,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: locController
                                  .locationModel.value.messages!.status!.city!
                                  .map((items) {
                                return DropdownMenuItem(
                                  onTap: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.setString(ApiStrings.cityID,
                                        items.cityId.toString());
                                    preferences.setString(ApiStrings.cityName,
                                        items.cityName.toString());
                                  },
                                  value: items.cityName,
                                  child: Text(
                                    items.cityName!,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  getLocation = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        PrimaryButton(
                          width: double.maxFinite,
                          height: 47,
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            String? cityName =
                                preferences.getString(ApiStrings.cityName);
                            getLocation = cityName;
                            dashController.getDashboard();
                            debugPrint(getLocation);
                            checkLocation();
                            // Get.to(()=> const BottomNavBar());
                          },
                          child: const Text(
                            'SAVE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }
}
