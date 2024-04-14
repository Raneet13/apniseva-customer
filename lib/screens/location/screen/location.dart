import 'package:apniseva/controller/dashboard_controller/dash_controller.dart';
import 'package:apniseva/controller/location_controller/location_controller.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key,
  }) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {

  String? getLocation;

  Future<String?> getCity() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString(ApiStrings.cityName);
    getLocation = location;

   if(getLocation == null){
     preferences.setString(ApiStrings.cityID, '23');
      getLocation = "Bhubaneswar";
    }else{
      getLocation = location;
    }
    debugPrint("Get Location: $getLocation");
    return getLocation;
  }

  final locController = Get.put(LocationController());
  final dashController = Get.put(DashController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      locController.getLoc();
    });
    getCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return SimpleDialog(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              title: Text('Choose Location',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              children:  [
                locController.isLoading.value == true ?
                Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2.5,
                      ),
                    )
                ):

                Container(
                  height: 47,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: getLocation,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: locController.locationModel.value.messages?.status!.city!.map((items) {
                        return DropdownMenuItem(
                          onTap: () async{
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            preferences.setString(ApiStrings.cityID, items.cityId.toString());
                            preferences.setString(ApiStrings.cityName, items.cityName.toString());
                          },
                          value: items.cityName,
                          child: Text(items.cityName!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        );}).toList(),
                      onChanged: (String? newValue) async{
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
                    onPressed: () async{
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      String? cityName = preferences.getString(ApiStrings.cityName);
                      getLocation = cityName;
                      dashController.getDashboard();
                      debugPrint("Loc: $getLocation");
                      Get.back();
                    },
                    child: const Text('SAVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                )
              ],
            );
      }
    );

  }
}

