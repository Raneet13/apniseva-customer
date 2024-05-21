import 'package:apniseva/controller/auth_controller/auth_controller.dart';
import 'package:apniseva/controller/dashboard_controller/dash_controller.dart';
import 'package:apniseva/screens/dashboard/sections/dash_reviews.dart';
import 'package:apniseva/screens/dashboard/sections/dash_services.dart';
import 'package:apniseva/screens/dashboard/widget/dash_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/color.dart';
import '../../../utils/input_field.dart';
import '../../location/screen/location.dart';
import '../sections/dash_appbar.dart';
import '../sections/dash_carousel.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  DateTime lastTimeBackButtonWasClicked = DateTime.now();

  final AuthController authController = Get.put(AuthController());
  final DashController dashController = Get.put(DashController());

  @override
  void initState() {
    checkUserLoc();
    super.initState();
  }

  checkUserLoc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? otp = preferences.getString(ApiStrings.otp);
    String? cityID = preferences.getString(ApiStrings.cityID);

    if (cityID!.isEmpty) {
      Future.delayed(Duration.zero, () {
        authController.getUserData();
      });

      preferences.getString(ApiStrings.cityID);
      showDialog(
          context: context,
          builder: (context) {
            return const GetLocation();
          });
    } else {
      Future.delayed(Duration.zero, () {
        dashController.getDashboard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Obx(() {
      return Scaffold(
        appBar:
            dashController.isLoading.value == true ? null : const DashAppBar(),
        body: dashController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 2.5,
                ),
              )
            : Container(
                width: width,
                height: height,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SearchField(),
                      SizedBox(height: height * 0.04),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DashStrings.ourServices,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      DashCategory(
                        getData: dashController
                            .dashDataModel.value.messages!.status!.categoryDtl!,
                      ),
                      SizedBox(height: height * 0.02),
                      DashCarousel(
                        getData: dashController
                            .dashDataModel.value.messages!.status!.offerDtl!,
                      ),
                      SizedBox(height: height * 0.02),
                      // Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       'Your Reviews',
                      //       style: Theme.of(context).textTheme.headlineLarge,
                      //     )),
                      // DashReviews(
                      //   getTestimonialDetail: dashController.dashDataModel.value
                      //       .messages!.status!.testimonialDtl!,
                      // )
                    ],
                  ),
                )),
      );
    });
  }
}
