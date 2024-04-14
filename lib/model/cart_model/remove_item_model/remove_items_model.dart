// To parse this JSON data, do
//
//     final removeItemDataModel = removeItemDataModelFromJson(jsonString);

import 'dart:convert';

RemoveItemDataModel removeItemDataModelFromJson(String str) => RemoveItemDataModel.fromJson(json.decode(str));

String removeItemDataModelToJson(RemoveItemDataModel data) => json.encode(data.toJson());

class RemoveItemDataModel {
  RemoveItemDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory RemoveItemDataModel.fromJson(Map<String, dynamic> json) => RemoveItemDataModel(
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
