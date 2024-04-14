// To parse this JSON data, do
//
//     final checkOutDataModel = checkOutDataModelFromJson(jsonString);

import 'dart:convert';

CheckOutDataModel checkOutDataModelFromJson(String str) => CheckOutDataModel.fromJson(json.decode(str));

String checkOutDataModelToJson(CheckOutDataModel data) => json.encode(data.toJson());

class CheckOutDataModel {
  CheckOutDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory CheckOutDataModel.fromJson(Map<String, dynamic> json) => CheckOutDataModel(
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
  String? status;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    responsecode: json["responsecode"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "responsecode": responsecode,
    "status": status,
  };
}
