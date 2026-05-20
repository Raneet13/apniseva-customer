import 'dart:convert';

import 'package:apniseva/model/order_model/order_model.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


class OrderController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool fetchAcceptOrder = false.obs;
  RxBool fetchOrder = false.obs;
  RxBool fetchPDF = false.obs;
  int? statusId;
  Rx<OrderDataModel> orderDataModel = OrderDataModel().obs;

  getOrders() async{
    try{
      fetchOrder.value = true;
      OrderDataModel orderModel = OrderDataModel();
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? userID = pref.getString(ApiStrings.userID);
      
      if (userID == null) {
        fetchOrder.value = false;
        // Provide empty model to avoid null errors in UI
        orderDataModel.value = OrderDataModel(
          status: 200,
          messages: Messages(
            status: Status(orderdtls: [])
          )
        );
        return false;
      }

      String? orderAPI = ApiEndPoint.getOrder;

      debugPrint(userID);
      debugPrint(orderAPI);

      Map<String, String> body = {
        "user_id": userID
      };

      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(
        Uri.parse(orderAPI),
        body: jsonEncode(body),
        headers: header
      );
      debugPrint('OrderAPI Status Code: ${response.statusCode}');
      orderModel = orderDataModelFromJson(response.body);

      if(response.statusCode == 200 && orderModel.status == 200) {
        orderDataModel.value = orderModel;
      }
      fetchOrder.value = false;

      return true;
    }catch(error) {
      fetchOrder.value = false;
      isLoading.value = false;
      debugPrint("Error in getOrders: $error");
      return false;
    }
  }

  acceptRejectOrder(String? orderID) async{
    try{
      isLoading.value = true;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userID = preferences.getString(ApiStrings.userID);
      
      if (userID == null || orderID == null || statusId == null) {
        isLoading.value = false;
        return;
      }

      String? acceptRejectOrderAPI = ApiEndPoint.acceptRejectOrder;

      Map<String, dynamic> body = {
        "user_id": userID,
        'order_id': orderID,
        'status_id': statusId!
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(
          Uri.parse(acceptRejectOrderAPI),
          body: jsonEncode(body),
          headers: headers
      );

      if(response.statusCode == 200) {
        isLoading.value = false;
        getOrders();
        debugPrint(response.body.toString());
      }
    }catch(e){
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  generatePDF(String? orderID) async{
    try{
      if (orderID == null) return;
      
      fetchPDF.value = true;
      String? pdfAPI = ApiEndPoint.generatePDF;

      Map<String, String> body = {
        'order_id': orderID,
      };

      Map<String, String> headers = {
        "Content-Type": "application/json; charset=utf-8"
      };

      http.Response response = await http.post(
          Uri.parse(pdfAPI),
          body: jsonEncode(body),
          headers: headers
      );

      if(response.statusCode == 200){
        fetchPDF.value = false;
        getOrders();
        debugPrint(response.body.toString());
      }
    } catch(e){
      fetchPDF.value = false;
      debugPrint(e.toString());
    }
  }
}