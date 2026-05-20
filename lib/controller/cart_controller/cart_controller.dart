import 'dart:convert';

import 'package:apniseva/model/cart_model/cart_detail_model/cart_details_model.dart';
import 'package:apniseva/model/cart_model/coupon_model/coupon_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart_model/add_to_cart_model/add_to_cart_model.dart';
import '../../model/cart_model/checkout_model/checkout_data_model.dart';
import '../../model/cart_model/remove_item_model/remove_items_model.dart';
import '../../screens/sucessful/screen/sucessfull_screen.dart';

class CartController extends GetxController {
  Rx fetch = false.obs;
  String? paymentMode = "cash";
  String? razorPayKey = 'rzp_live_pEiadfp4ZIDBJT'; //rzp_live_pEiadfp4ZIDBJT
  String? addressID;
  String? firstName;
  String? lastName;
  String? number;
  String? email;
  String? address1;
  String? address2;
  String? cityName;
  String? state;
  String? pinCode;
  String? userId;
  String? payment_id;
  int? paid_amount;
  List? productName = [];
  List? price = [];
  List? qty = [];
  List? image = [];
  List? parentId = [];
  Rx addcartTrue = false.obs;
  int cartTtalAmount = 0;

  Rx<AddToCartDataModel> addToCartDataModel = AddToCartDataModel().obs;
  Rx<CartDetailsDataModel> cartDetailsDataModel = CartDetailsDataModel().obs;
  Rx<RemoveItemDataModel> removeItemDataModel = RemoveItemDataModel().obs;
  Rx<CouponDataModel> couponDataModel = CouponDataModel().obs;
  Rx<CheckOutDataModel> checkoutDataModel = CheckOutDataModel().obs;

  TextEditingController couponTextController = TextEditingController();
  TextEditingController gstTextController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController redateController = TextEditingController();
  TextEditingController retimeController = TextEditingController();

  addToCart() async {
    try {
      fetch.value = true;
      AddToCartDataModel addToCartModel = AddToCartDataModel();

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      String? serviceID = preferences.getString(ApiStrings.serviceID);
      String? categoryID = preferences.getString(ApiStrings.catID);
      String? productQty = preferences.getString(ApiStrings.productQty);

      if (userID == null) {
        fetch.value = false;
        Get.snackbar('Login Required', 'Please login to add items to cart');
        return;
      }

      String? addToCartAPI = ApiEndPoint.addToCart;
      userId = userID;
      Map<String, String> body = {
        'user_id': userID,
        'service_id': serviceID!,
        'category_id': categoryID!,
        'product_qty': productQty!,
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(addToCartAPI),
          body: jsonEncode(body), headers: headers);
      debugPrint('Add To Cart API Status Code:${response.statusCode}');
      debugPrint('Add To Cart Body:$body');
      addToCartModel = addToCartDataModelFromJson(response.body);

      if (response.statusCode == 200 && addToCartModel.status == 200) {
        addToCartDataModel.value = addToCartModel;
        Get.snackbar(
            'Cart', addToCartDataModel.value.messages!.status.toString(),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
        fetch.value = false;
      }
      preferences.remove(ApiStrings.catID);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      fetch.value = false;
    }
  }

  getCartData() async {
    clear();
    try {
      fetch.value = true;
      CartDetailsDataModel cartModel = CartDetailsDataModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      String? cityID = preferences.getString(ApiStrings.cityID);
      
      if (userID == null || cityID == null) {
        fetch.value = false;
        return;
      }

      String? addressIDPref = preferences.getString(ApiStrings.addressID);
      dateController.text = DateFormat('dd-MM-yyyy')
          .format(DateTime.now()); //datetime when cart load
      timeController.text = DateFormat('hh:mm a').format(DateTime.now());
      debugPrint("userId:${userID} & city_id:${cityID}");
      addressID = addressIDPref;

      String? cartAPI = ApiEndPoint.cartDetails;

      Map<String, String> body = {'user_id': userID, 'city_id': cityID};

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(cartAPI),
          body: jsonEncode(body), headers: headers);

      // debugPrint("CartAPI: ${response.body.toString()}");
      cartModel = cartDetailsDataModelFromJson(response.body);

      if (response.statusCode == 200 && cartModel.status == 200) {
        cartDetailsDataModel.value = cartModel;
        // print(cartModel.toJson());
        //fetch address of previous
        if (addressID != null && cartModel.messages?.status?.addressData != null) {
          int indexAddress = cartModel.messages!.status!.addressData!
              .indexWhere((map) => map.addressId == addressID);
          if (indexAddress != -1) {
            AddressDatum addressData =
                cartModel.messages!.status!.addressData![indexAddress];
            //address
            firstName = addressData.firstName;
            lastName = addressData.lastName;
            number = addressData.number;
            email = addressData.email;
            address1 = addressData.address1;
            address2 = addressData.adress2;
            state = addressData.state;
            pinCode = addressData.pincode;
          }
        }
        //address
        //Fetch Address of previous
        fetch.value = false;
      }

      if (cartDetailsDataModel.value.messages?.status?.allCart != null) {
        for (int i = 0;
            i < cartDetailsDataModel.value.messages!.status!.allCart!.length;
            i++) {
          var cartData = cartDetailsDataModel.value.messages!.status!.allCart![i];

          productName!.add(cartData.servicename);
          image!.add(cartData.image);
          qty!.add(cartData.qty);
          price!.add(cartData.price);
          parentId!.add(cartData.parentIdId);
          cartTtalAmount = cartTtalAmount + int.parse(cartData.price.toString());
        }
      }
      fetch.value = false;
    } catch (e) {
      fetch.value = false;
      debugPrint("Error in getCartData: $e");
      return false;
    }
  }

  cartTrueFalse(String serviceName) {
    if (cartDetailsDataModel.value.messages?.status?.allCart == null) return false;

    fetch.value = true;
    final CartController cartController = Get.find<CartController>();

    bool cartTrue = false;
    for (var i = 0;
        i <
            cartController
                .cartDetailsDataModel.value.messages!.status!.allCart!.length;
        i++) {
      if (serviceName ==
          cartController.cartDetailsDataModel.value.messages!.status!
              .allCart![i].servicename) {
        addcartTrue.value = true;

        cartTrue = true;
        update();
      }
    }
    fetch.value = false;
    return cartTrue;
  }

  removeItem() async {
    fetch.value = true;
    RemoveItemDataModel removeItemModel = RemoveItemDataModel();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cartID = preferences.getString(ApiStrings.cartID);
    
    if (cartID == null) {
      fetch.value = false;
      return;
    }

    String? removeItemAPI = ApiEndPoint.removeItems;

    Map<String, String> body = {'cart_id': cartID};

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8"
    };

    http.Response response = await http.post(Uri.parse(removeItemAPI),
        body: jsonEncode(body), headers: headers);
    debugPrint('RemoveItem: ${response.statusCode}');
    removeItemModel = removeItemDataModelFromJson(response.body);

    if (response.statusCode == 200 && removeItemModel.status == 200) {
      removeItemDataModel.value == removeItemModel;
      fetch.value = false;
    } else {
      Get.snackbar('Cart', 'Something went wrong');
    }
    fetch.value = false;
  }

  applyCoupon() async {
    fetch.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CouponDataModel couponModel = CouponDataModel();

    String? userID = preferences.getString(ApiStrings.userID);
    String? cityID = preferences.getString(ApiStrings.cityID);
    
    if (userID == null || cityID == null) {
      fetch.value = false;
      return;
    }

    String? couponCode = couponTextController.text;
    String? couponAPI = ApiEndPoint.applyCoupon;

    Map<String, String> body = {
      'user_id': userID,
      'city_id': cityID,
      'coupon_code': couponCode
    };

    Map<String, String> header = {
      "Content-Type": "application/json; charset=utf-8"
    };

    http.Response response = await http.post(Uri.parse(couponAPI),
        body: jsonEncode(body), headers: header);

    debugPrint('CouponAPI: ${response.statusCode}');
    couponModel = couponDataModelFromJson(response.body);

    if (response.statusCode == 200 && couponModel.status == 200) {
      couponDataModel.value = couponModel;
      if (couponDataModel.value.messages?.status?.couponDetails != null) {
        preferences.setString(ApiStrings.couponCharge,
            couponDataModel.value.messages!.status!.couponDetails!.couponAmount!);
      }
      if (couponDataModel.value.messages?.status?.gst != null) {
        preferences.setString(ApiStrings.gstAmount,
            couponDataModel.value.messages!.status!.gst!.gstAmount!);
      }
      fetch.value = false;
    }
    fetch.value = false;
  }

  applyGst() async {
    print(gstTextController.text);
    fetch.value = false;
  }

  checkOut() async {
    CheckOutDataModel checkOutModel = CheckOutDataModel();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userID = preferences.getString(ApiStrings.userID);
    String? couponAmount = preferences.getString(ApiStrings.couponCharge) ?? "0";
    String? gstAmount = preferences.getString(ApiStrings.gstAmount) ?? "0";
    String? addressID = preferences.getString(ApiStrings.addressID);

    if (userID == null) {
      Get.snackbar('Error', 'Please login to checkout');
      return;
    }

    String? checkOutAPI = ApiEndPoint.checkout;
    Map<String, dynamic> body = {
      'user_id': userID,
      'paymentmode': paymentMode == "online" ? "2" : "1",
      'date': dateController.text,
      'time': timeController.text,
      'productname': productName.toString(),
      'price': price.toString(),
      'qty': qty.toString(),
      'image': image.toString(),
      'cupone_code': couponTextController.text,
      'cupone_charge': couponAmount,
      'gst': gstAmount,
      'address_id': addressID,
      'parent_id': parentId.toString(),
      'gstno': gstTextController.text,
      'payment_id': payment_id,
      'paid_amount': paid_amount
    };

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8"
    };

    http.Response response = await http.post(Uri.parse(checkOutAPI),
        body: jsonEncode(body), headers: headers);
    print(response.body);
    checkOutModel = checkOutDataModelFromJson(response.body);
    if (response.statusCode == 200 && checkOutModel.status == 200) {
      checkoutDataModel.value = checkOutModel;
      fetch.value = false;
      Get.snackbar('Cart', 'Submitted');
      Get.to(() => const SuccessfulScreen());
    }
    fetch.value = false;

    clear();
  }

  clear() {
    productName!.clear();
    image!.clear();
    qty!.clear();
    price!.clear();
    image!.clear();
    parentId!.clear();
    cartTtalAmount = 0;
  }

  Reshedule() async {
    fetch.value = true;
    String date = redateController.text.toString();
    String time = retimeController.text.toString();
    DateTime newDate = DateTime.now();
    var ttt = "$date $time";

    try {
      if (newDate.isBefore(DateFormat("dd-MM-yyyy hh:mm a").parse(ttt))) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? orderID = preferences.getString(ApiStrings.orderID);

        if (orderID == null) {
          fetch.value = false;
          return;
        }

        String? resheduleApi = ApiEndPoint.reshedule;

        Map<String, dynamic> body = {
          'orderid': orderID,
          'rdate': date,
          'rtime': time,
        };

        Map<String, String> headers = {
          "Content-Type": "application/json; charset=utf-8"
        };

        http.Response response = await http.post(Uri.parse(resheduleApi),
            body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
          fetch.value = false;
          Get.snackbar('Shedule', 'Sucess');
        }
        fetch.value = false;
      } else {
        Get.snackbar('Shedule', 'We not provide service before currect time',
            backgroundColor: Colors.red);
        fetch.value = false;
      }
    } catch (e) {
      debugPrint("Error in Reshedule: $e");
      fetch.value = false;
    }
  }

  deletItemFrmCart() async {
    fetch.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cartID = preferences.getString(ApiStrings.cartID);

    if (cartID == null) {
      Get.snackbar('Cart', 'Cart is already empty');
      fetch.value = false;
      return;
    }

    String? removeItemAPI = ApiEndPoint.removeItems;
    print(cartID);
    Map<String, String> body = {'cart_id': cartID};

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8"
    };

    http.Response response = await http.post(Uri.parse(removeItemAPI),
        body: jsonEncode(body), headers: headers);
    getCartData();
    debugPrint('RemoveItem: ${response.statusCode}');

    if (response.statusCode == 200) {
      Get.snackbar('Item Delete', 'Sucess');
      fetch.value = false;
    } else {
      Get.snackbar('Cart', 'Cart is already empty');
    }
    fetch.value = false;
  }
}
