// To parse this JSON data, do
//
//     final addToCartDataModel = addToCartDataModelFromJson(jsonString);

import 'dart:convert';

AddToCartDataModel addToCartDataModelFromJson(String str) => AddToCartDataModel.fromJson(json.decode(str));

String addToCartDataModelToJson(AddToCartDataModel data) => json.encode(data.toJson());

class AddToCartDataModel {
  AddToCartDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory AddToCartDataModel.fromJson(Map<String, dynamic> json) => AddToCartDataModel(
    status: json["status"],
    error: json["error"],
    messages: Messages.fromJson(json["messages"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "messages": messages!.toJson(),
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