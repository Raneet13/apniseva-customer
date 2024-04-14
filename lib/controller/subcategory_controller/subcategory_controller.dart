import 'dart:convert';

import 'package:apniseva/model/dashboard_model/subcategory_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryController extends GetxController{
  RxBool isLoading = false.obs;
  Rx<SubCategoryDataModel> subCategoryDataModel = SubCategoryDataModel().obs;

  getSubCat() async{
    try{
      isLoading.value = true;
      SubCategoryDataModel subCatModel = SubCategoryDataModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? catID = preferences.getString(ApiStrings.catID);
      String? userID = preferences.getString(ApiStrings.userID);
      String? cityID = preferences.getString(ApiStrings.cityID);

      String? subCatAPI = ApiEndPoint.subCat;

      Map<String, String> body = {
        'user_id': userID!,
        'cat_id': catID!,
        'city_id': cityID!
      };
      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(
        Uri.parse(subCatAPI),
        body: jsonEncode(body),
        headers: header
      );
      // debugPrint(response.body);
      subCatModel = subCategoryDataModelFromJson(response.body);

      if(response.statusCode == 200 && subCatModel.status == 200){
        subCategoryDataModel.value = subCatModel;
        isLoading.value = false;
      }

      return true;
    }catch(e) {
      isLoading.value = false;
      Get.snackbar('SubCategory', 'Something Went Wrong');
    }
  }

}