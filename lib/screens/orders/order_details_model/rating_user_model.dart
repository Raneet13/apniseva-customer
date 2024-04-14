// To parse this JSON data, do
//
//     final ratingModelUser = ratingModelUserFromJson(jsonString);

import 'dart:convert';

RatingModelUser ratingModelUserFromJson(String str) =>
    RatingModelUser.fromJson(json.decode(str));

String ratingModelUserToJson(RatingModelUser data) =>
    json.encode(data.toJson());

class RatingModelUser {
  final int? status;
  final bool? error;
  final Messages? messages;

  RatingModelUser({
    this.status,
    this.error,
    this.messages,
  });

  factory RatingModelUser.fromJson(Map<String, dynamic> json) =>
      RatingModelUser(
        status: json["status"],
        error: json["error"],
        messages: json["messages"] == null
            ? null
            : Messages.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages?.toJson(),
      };
}

class Messages {
  final String? responsecode;
  final String? status;

  Messages({
    this.responsecode,
    this.status,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        responsecode: json["responsecode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "responsecode": responsecode,
        "status": status,
      };
}
