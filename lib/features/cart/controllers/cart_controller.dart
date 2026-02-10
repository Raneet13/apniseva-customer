import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/network/api_endpoints.dart';

import '../../models/cart_details_model.dart';
import '../../models/coupon_model.dart';
import '../../models/add_to_cart_model.dart';
import '../../models/checkout_model.dart';
import '../../models/remove_item_model.dart';

class CartController extends GetxController {
  RxBool fetch = false.obs;

  String? paymentMode = "cash";

  String? razorPayKey = 'rzp_live_pEiadfp4ZIDBJT';

  String? addressID;

  Rx<AddToCartDataModel> addToCartDataModel = AddToCartDataModel().obs;

  Rx<CartDetailsDataModel> cartDetailsDataModel = CartDetailsDataModel().obs;

  Rx<CouponDataModel> couponDataModel = CouponDataModel().obs;

  Rx<CheckOutDataModel> checkoutDataModel = CheckOutDataModel().obs;

  TextEditingController couponTextController = TextEditingController();

  TextEditingController gstTextController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  int cartTotalAmount = 0;

  Future<void> getCartData() async {
    fetch.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userID = prefs.getString(StorageKeys.userId);

      String? cityID = prefs.getString(StorageKeys.cityId);

      dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

      timeController.text = DateFormat('hh:mm a').format(DateTime.now());

      Map<String, String> body = {
        "user_id": userID ?? "",
        "city_id": cityID ?? "",
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.cartDetails),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        cartDetailsDataModel.value =
            cartDetailsDataModelFromJson(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    fetch.value = false;
  }

  Future<void> applyCoupon() async {
    fetch.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userID = prefs.getString(StorageKeys.userId);

      String? cityID = prefs.getString(StorageKeys.cityId);

      Map<String, String> body = {
        "user_id": userID ?? "",
        "city_id": cityID ?? "",
        "coupon_code": couponTextController.text,
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.applyCoupon),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        couponDataModel.value = couponDataModelFromJson(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    fetch.value = false;
  }

  Future<void> removeItem() async {
    fetch.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? cartID = prefs.getString(StorageKeys.cartId);

      final response = await http.post(
        Uri.parse(ApiEndpoints.removeItems),
        body: jsonEncode({"cart_id": cartID}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        getCartData();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    fetch.value = false;
  }

  Future<void> checkout() async {
    fetch.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userID = prefs.getString(StorageKeys.userId);

      final response = await http.post(
        Uri.parse(ApiEndpoints.checkout),
        body: jsonEncode({
          "user_id": userID,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        checkoutDataModel.value = checkOutDataModelFromJson(response.body);

        Get.snackbar("Success", "Order placed successfully");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    fetch.value = false;
  }
}
