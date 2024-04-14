import 'package:apniseva/model/dashboard_model/subcategory_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/subcategory_controller/subcategory_controller.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../service/screens/service_screen.dart';

class ChooseSubCategory extends StatefulWidget {
  const ChooseSubCategory({Key? key,
  }) : super(key: key);

  @override
  State<ChooseSubCategory> createState() => _ChooseSubCategoryState();
}

class _ChooseSubCategoryState extends State<ChooseSubCategory> {

  final subCategoryController = Get.put(SubCategoryController());

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      subCategoryController.getSubCat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.6,
      // alignment: Alignment.center,
      decoration:  BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text('Choose Category',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          const Divider(),

          Obx(() {
              return Container(
                height: height * 0.52,
                // alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(left: 10),
                child: subCategoryController.isLoading.value == true ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Theme.of(context).primaryColor,
                    )
                ) :
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 0,
                        crossAxisCount: 3,
                        childAspectRatio: 0.74
                    ),
                    itemCount:  subCategoryController.subCategoryDataModel.value.messages!.status!.categoryDtl!.length,
                    itemBuilder: (BuildContext context, int index){
                      List<CategoryDtl>? data = subCategoryController.subCategoryDataModel.value.messages!.status!.categoryDtl;
                      return InkWell(
                        onTap: () async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          preferences.setString(ApiStrings.catID, data![index].catId!);
                          // debugPrint("SubCategory: ${data[index].catName}");
                          // debugPrint("SubCategory: ${data[index].catId}");

                          if(data[index].subcat == 1){
                            Get.to(()=> const ServiceScreen());
                          }else {
                            showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return const ChooseSubCategory();
                                });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 0.4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Container(
                                height: 110,
                                width: 110,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network('${ApiEndPoint.imageAPI}/${data?[index].catImg}',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.blue,
                                child: Text(data?[index].catName ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                )
              );
            }
          ),
        ],
      ),
    );
  }
}
