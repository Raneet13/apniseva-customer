// To parse this JSON data, do
//
//     final addAdressModel = addAdressModelFromJson(jsonString);

import 'dart:convert';

AddAdressModel addAdressModelFromJson(String str) => AddAdressModel.fromJson(json.decode(str));

String addAdressModelToJson(AddAdressModel data) => json.encode(data.toJson());

class AddAdressModel {
  AddAdressModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory AddAdressModel.fromJson(Map<String, dynamic> json) => AddAdressModel(
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
