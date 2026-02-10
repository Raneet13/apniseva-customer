import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/storage/storage_service.dart';
import '../controller/dash_controller.dart';

import '../../presentation/controller/dashboard_controller.dart';

import '../../presentation/widgets/dash_appbar.dart';
import '../../presentation/widgets/dash_carousel.dart';
import '../../presentation/widgets/dash_services.dart';
import '../../presentation/widgets/dash_reviews.dart';

import '../../../../shared/widgets/input_fields/search_field.dart';

import '../../../location/presentation/views/location_dialog.dart';

import '../../../../shared/theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.find<DashboardController>();

  final StorageService storage = Get.find<StorageService>();

  @override
  void initState() {
    super.initState();

    checkUserLoc();
  }

  Future<void> checkUserLoc() async {
    final cityID = storage.cityId;

    if (cityID == null || cityID.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const LocationDialog(),
      );
    } else {
      controller.getDashboard();
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
        appBar: controller.isLoading.value ? null : const DashAppBar(),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2.5,
              ))
            : Container(
                width: width,
                height: height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SearchField(),
                      SizedBox(height: height * 0.04),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Our Services",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      DashCategory(
                        getData: controller
                            .dashDataModel.value.messages!.status!.categoryDtl!,
                      ),
                      const Divider(),
                      DashCarousel(
                        getData: controller
                            .dashDataModel.value.messages!.status!.offerDtl!,
                      ),
                      const Divider(),
                      SizedBox(height: height * 0.02),
                      buildFooterBrand(),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget buildFooterBrand() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
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
                  fontFamily: 'Inter',
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
                  const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFFF5E5E),
                    size: 34,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
