import 'dart:convert';

import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/address_model/add_address_model/add_address_model.dart';
import '../../model/address_model/update_address_model/update_address_model.dart';

class AddressController extends GetxController{
  RxBool isLoading = false.obs;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  // final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController pinCode = TextEditingController();


  Rx<UpdateAddressModel> updateAddressModel = UpdateAddressModel().obs;
  Rx<AddAdressModel> addAddressModel = AddAdressModel().obs;

addAddress() async {

  AddAdressModel addAdressDataModel = AddAdressModel();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? userID = preferences.getString(ApiStrings.userID);
  String? cityID = preferences.getString(ApiStrings.cityID);
  String? addressAPI = ApiEndPoint.addressAPI;

  try{
    isLoading.value = true;
    Map<String, String> body = {
      'user_id': userID!,
      'firstname': firstName.text,
      'lasttname': lastName.text,
      'email': email.text,
      'phone': phone.text,
      'address1': address1.text,
      'address2': address2.text,
      'city': cityID!,
      'state': state.text,
      'zip': pinCode.text.toString(),
    };

    Map<String, String> headers = {
      "Content-Type": 'application/json'
    };

    http.Response response = await http.post(
      Uri.parse(addressAPI),
      body: jsonEncode(body),
      headers: headers
    );
    debugPrint(body.toString());
    debugPrint(response.statusCode.toString());

    if(response.statusCode == 200) {
      addAddressModel.value = addAdressModelFromJson(response.body);
      Get.snackbar('Address', addAddressModel.value.messages!.status!,
          colorText: Colors.white
      );
      isLoading.value = false;
    }
    debugPrint(response.body);

  }catch(e){
    isLoading.value = false;
    Get.snackbar('Address', e.toString());
    debugPrint(e.toString());
  }

}

updateAddress() async{
  UpdateAddressModel updateAddressDataModel = UpdateAddressModel();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? addressID = preferences.getString(ApiStrings.addressID);
  String? userID = preferences.getString(ApiStrings.userID);
  String? cityID = preferences.getString(ApiStrings.cityID);

  String? updateAddressAPI = ApiEndPoint.updateAddress;

  try{
    isLoading.value = true;

    Map<String, String> header = {
      "Content-Type": 'application/json'
    };
    Map<String, String> body = {
      'user_id': userID!,
      "address_id": addressID!,
      'firstname': firstName.text,
      'lasttname': lastName.text,
      'email': email.text,
      'phone': phone.text,
      'address1': address1.text,
      'address2': address2.text,
      'city': cityID!,
      'state': state.text,
      'zip': pinCode.text,
    };

    http.Response response = await http.post(
      Uri.parse(updateAddressAPI),
      body: jsonEncode(body),
      headers: header
    );
    debugPrint("Update Address: ${response.body}");
    Map data = jsonDecode(response.body);

    if(response.statusCode == 200) {
      debugPrint("Sucessfull");
      updateAddressModel.value = updateAddressModelFromJson(response.body);
      Get.snackbar('Updated Adress',updateAddressModel.value.messages!.status!,
        colorText: Colors.white
      );
    }

  }catch(e){
    debugPrint(e.toString());
  }

}
}