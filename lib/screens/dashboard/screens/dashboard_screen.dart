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
                      SizedBox(height: height * 0.02),
                      _buildFooterBrand(context),
                    ],
                  ),
                )),
      );
    });
  }

  Widget _buildFooterBrand(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/images/odisha_image.png",
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Odisha's Own",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD6D6D6),
                  height: 1.0,
                  letterSpacing: -1.5,
                  fontFamily:
                      'Inter', // Try to use a nice font if available, or fallback
                ),
              ),
              Row(
                children: [
                  Text(
                    "app",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD6D6D6),
                      height: 1.0,
                      letterSpacing: -1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFFF5E5E),
                      size: 34,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                height: 2,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "apniseva",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFE0E0E0),
                  letterSpacing: -1.0,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
