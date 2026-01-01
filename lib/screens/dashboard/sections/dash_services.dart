import 'package:apniseva/model/dashboard_model/dash_model.dart';
import 'package:apniseva/screens/dashboard/sections/sub_category_modal.dart';
import 'package:apniseva/screens/dashboard/widget/dash_strings.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/bottom_nav_bar.dart';

class DashCategory extends StatefulWidget {
  final List<CategoryDtl>? getData;
  const DashCategory({
    Key? key,
    this.getData = const [],
  }) : super(key: key);

  @override
  State<DashCategory> createState() => _DashCategoryState();
}

class _DashCategoryState extends State<DashCategory> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height-(MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget.getData!.isEmpty
          ? Container(
              width: width,
              height: 150,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    DashServicesStrings.noData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              itemCount: widget.getData!.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.80,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                List<CategoryDtl> data = widget.getData!;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString(
                          ApiStrings.catID, data[index].catId!);
                      debugPrint("Category: ${data[index].catId}");
                      isModalOpen = true;
                      showBottomSheet(
                        context: context,
                        builder: (context) {
                          return const ChooseSubCategory();
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade900.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                // Decorative background blob
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  left: -10,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.blue.shade100.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                // Image/Icon
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    child: Image.network(
                                      '${ApiEndPoint.imageAPI}/${data[index].catImg!}',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.category_rounded,
                                          color: Colors.blue.shade200,
                                          size: 32,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data[index].catName!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.blueGrey.shade900,
                            height: 1.2,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
