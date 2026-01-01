import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/subcategory_controller/subcategory_controller.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../service/screens/service_screen.dart';

class ChooseSubCategory extends StatefulWidget {
  const ChooseSubCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseSubCategory> createState() => _ChooseSubCategoryState();
}

class _ChooseSubCategoryState extends State<ChooseSubCategory> {
  final subCategoryController = Get.put(SubCategoryController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      subCategoryController.getSubCat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: height * 0.7,
        minHeight: height * 0.4,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar for bottom sheet
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Select Sub-Category',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),

          Flexible(
            child: Obx(() {
              if (subCategoryController.isLoading.value) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }

              final categoryList = subCategoryController
                  .subCategoryDataModel.value.messages?.status?.categoryDtl;

              if (categoryList == null || categoryList.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = categoryList[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString(ApiStrings.catID, item.catId!);

                        if (item.subcat == 1) {
                          Get.to(() => const ServiceScreen());
                        } else {
                          // Note: In a real app, you might want to push a new choice or refresh
                          subCategoryController.getSubCat();
                        }
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        children: [
                          Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade900.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -15,
                                    right: -15,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Image.network(
                                        '${ApiEndPoint.imageAPI}/${item.catImg}',
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.category_rounded,
                                            color: Colors.blue.shade200,
                                            size: 28,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.catName ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.blueGrey.shade800,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
