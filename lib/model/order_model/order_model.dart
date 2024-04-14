// To parse this JSON data, do
//
//     final orderDataModel = orderDataModelFromJson(jsonString);

import 'dart:convert';

OrderDataModel orderDataModelFromJson(String str) => OrderDataModel.fromJson(json.decode(str));

String orderDataModelToJson(OrderDataModel data) => json.encode(data.toJson());

class OrderDataModel {
  OrderDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory OrderDataModel.fromJson(Map<String, dynamic> json) => OrderDataModel(
    status: json["status"],
    error: json["error"],
    messages: json["messages"] == null ? null : Messages.fromJson(json["messages"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "messages": messages?.toJson(),
  };
}

class Messages {
  Messages({
    this.responsecode,
    this.status,
  });

  String? responsecode;
  Status? status;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    responsecode: json["responsecode"],
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "responsecode": responsecode,
    "status": status?.toJson(),
  };
}

class Status {
  Status({
    this.orderdtls,
  });

  List<Orderdtl>? orderdtls;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    orderdtls: List<Orderdtl>.from(json["Orderdtls"].map((x) => Orderdtl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Orderdtls": List<dynamic>.from(orderdtls!.map((x) => x.toJson())),
  };
}

class Orderdtl {
  Orderdtl({
    this.orderId,
    this.sheduleDate,
    this.sheduledTime,
    this.orderDateTime,
    this.status,
  });

  String? orderId;
  String? sheduleDate;
  String? sheduledTime;
  String? orderDateTime;
  String? status;

  factory Orderdtl.fromJson(Map<String, dynamic> json) => Orderdtl(
    orderId: json["Order_id"],
    sheduleDate: json["shedule_date"],
    sheduledTime: json["sheduled_time"],
    orderDateTime: json["Order_date_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "Order_id": orderId,
    "shedule_date": sheduleDate,
    "sheduled_time": sheduledTime,
    "Order_date_time": orderDateTime,
    "status": status,
  };
}
