import 'dart:convert';

import 'package:apniseva/screens/orders/order_details_model/order_details_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/orders/order_details_model/rating_user_model.dart';
import '../../utils/api_strings/api_strings.dart';

class OrderDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<OrderDetailDataModel> orderDetailsModel = OrderDetailDataModel().obs;
  Rx<RatingModelUser> ratingModel = RatingModelUser().obs;
  TextEditingController technicianFeedbackController = TextEditingController();
  TextEditingController cmpanyFeedbackController = TextEditingController();
  double rateTechnician = 0.0;
  double rateCompany = 0.0;
  String? paymentId;
  String? razorPayKey = 'rzp_live_pEiadfp4ZIDBJT'; //rzp_live_pEiadfp4ZIDBJT
  int? payAmount;
  String? firstName;
  String? number;
  String? email;
  String? userId;

  aceptAdditionalBill() async {
    try {
      isLoading.value = true;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      String? orderID = preferences.getString(ApiStrings.orderID);
      String? technicianID = preferences.getString(ApiStrings.technicianId);
      // String? technicianRating = preferences.getString(ApiStrings.ratngTechniian);
      // String? technicianRview = preferences.getString(ApiStrings.userID);
      // String? companyRating = preferences.getString(ApiStrings.orderID);
      // String? companyReviiew = preferences.getString(ApiStrings.orderID);

      String? acceptaditinalorder = ApiEndPoint.acceptAditinalOrder;
      Map<String, String> body = {
        'order_id': orderID!,
        'status': "3",
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(acceptaditinalorder),
          body: jsonEncode(body), headers: headers);
      //   debugPrint("Status Code: ${response.statusCode.toString()}");
      //   debugPrint("Status Code: ${response.body.toString()}");
      // ratingModel = ratingModelUserFromJson(response.body);

      if (response.statusCode == 200) {
        // print('orderDeetails ${response.body}');
        // ratingModel.value = orderModel;
        getOrderDetails();
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
      // Get.snackbar("Order Details", e.toString(),
      //     colorText: Colors.black,
      //     backgroundColor: Colors.white54
      // );
      return false;
    }
  }

  getOrderDetails() async {
    try {
      isLoading.value = true;
      OrderDetailDataModel orderModel = OrderDetailDataModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      String? orderID = preferences.getString(ApiStrings.orderID);

      String? orderDetailsAPI = ApiEndPoint.getOrderDetails;
      // debugPrint(orderDetailsAPI);

      Map<String, String> body = {'user_id': userID!, 'order_id': orderID!};

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(orderDetailsAPI),
          body: jsonEncode(body), headers: headers);
      // debugPrint("Status Code: ${response.statusCode.toString()}");
      // print(response.statusCode);
      // debugPrint("Status Code: ${response.body.toString()}");
      orderModel = orderDetailDataModelFromJson(response.body);

      if (response.statusCode == 200) {
        // print("Status is corret");
        debugPrint('orderDeetails ${response.body}');
        orderDetailsModel.value = orderModel;
        firstName = orderModel.messages!.status!.address![0].firstName ?? "";
        email = orderModel.messages!.status!.address![0].email ?? "";
        number = orderModel.messages!.status!.address![0].number ?? "";
        userId = orderModel.messages!.status!.address![0].userId ?? "";
        await preferences.setString("Technician_id",
            orderModel.messages!.status!.otherDtl!.technicianId ?? "");
        await preferences.setString("s_order_AddressID",
            orderModel.messages!.status!.address![0].addressId ?? "");

        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
      // Get.snackbar("Order Details", e.toString(),
      //     colorText: Colors.black,
      //     backgroundColor: Colors.white54
      // );
      return false;
    }
  }

  aditionalPayment() async {
    try {
      isLoading.value = true;
      // OrderDetailDataModel orderModel = OrderDetailDataModel();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userId = preferences.getString(ApiStrings.userID);
      String? orderID = preferences.getString(ApiStrings.orderID);
      String? addressID = preferences.getString("s_order_AddressID");
      String? technicianId = preferences.getString("Technician_id");

      String? aditionalPaymentAPI = ApiEndPoint.aditionalPayment;

      // debugPrint(
      //     'API${aditionalPaymentAPI},userID${userId},orderID${orderID},paymentID:${paymentId},addressID:${addressID},Paid Amunt:${payAmount},technicianID:${technicianId}');
      // print(
      //     "DEtails o extra things name:${firstName},email${email},userID${userId},number${number}");
      Map<String, String> body = {
        'user_id': userId!,
        'order_id': orderID!,
        'paymentmode': "2",
        'payment_id': paymentId!,
        'address_id': addressID!,
        'paid_amount': payAmount!.toString(),
        'vendor_id': technicianId!
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(aditionalPaymentAPI),
          body: jsonEncode(body), headers: headers);
      debugPrint("Status Code: additionoonal payment respnse");
      // debugPrint("Status Code: ${response.body.toString()}");
      // orderModel = orderDetailDataModelFromJson(response.body);

      if (response.statusCode == 200) {
        // print('aditioalpayment ${response.body}');S
        // orderDetailsModel.value = orderModel;
        getOrderDetails();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar("Something wrong",
            "We Couldnt proceed your payment plaease try again or contact APNISEVA if amount deducted",
            colorText: Colors.black, backgroundColor: Colors.white54);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
      Get.snackbar("Order Details", e.toString(),
          colorText: Colors.black, backgroundColor: Colors.white54);
      return false;
    }
  }

  rateAndRevew() async {
    try {
      isLoading.value = true;
      RatingModelUser ratingModel = RatingModelUser();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      String? orderID = preferences.getString(ApiStrings.orderID);
      String? technicianID = preferences.getString(ApiStrings.technicianId);
      // String? technicianRating = preferences.getString(ApiStrings.ratngTechniian);
      // String? technicianRview = preferences.getString(ApiStrings.userID);
      // String? companyRating = preferences.getString(ApiStrings.orderID);
      // String? companyReviiew = preferences.getString(ApiStrings.orderID);

      String? reviewRateApi = ApiEndPoint.submitRattinguser;
      debugPrint(reviewRateApi);
      debugPrint(
          "technicianrate${rateTechnician},companyrate${rateCompany},userID:${userID},orderID:${orderID},technicianID:${technicianID},technicianreview:${technicianFeedbackController.text},,companyreview:${cmpanyFeedbackController.text}");
//technicianrate${technicianRating},companyrate${companyRating}
      Map<String, String> body = {
        'order_id': orderID!,
        'from_user_id': userID!, //useer id
        'to_user_id': technicianID!, //technician id
        'rating': rateTechnician.toInt().toString(), //rating nuber tehnician
        'review': technicianFeedbackController.text, //reviewtechnician
        'crating': rateCompany.toInt().toString(), //company rating
        'creview': cmpanyFeedbackController.text //company review
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(Uri.parse(reviewRateApi),
          body: jsonEncode(body), headers: headers);
      //   debugPrint("Status Code: ${response.statusCode.toString()}");
      //   debugPrint("Status Code: ${response.body.toString()}");
      // ratingModel = ratingModelUserFromJson(response.body);

      if (response.statusCode == 200 && ratingModel.status! == 200) {
        // print('orderDeetails ${response.body}');
        // ratingModel.value = orderModel;
        await getOrderDetails();
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
      // Get.snackbar("Order Details", e.toString(),
      //     colorText: Colors.black,
      //     backgroundColor: Colors.white54
      // );
      return false;
    }
  }
}
