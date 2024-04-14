// To parse this JSON data, do
//
// final serviceDataModel = serviceDataModelFromJson(jsonString);

import 'dart:convert';

ServiceDataModel serviceDataModelFromJson(String str) =>
    ServiceDataModel.fromJson(json.decode(str));

String serviceDataModelToJson(ServiceDataModel data) =>
    json.encode(data.toJson());

class ServiceDataModel {
  ServiceDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory ServiceDataModel.fromJson(Map<String, dynamic> json) =>
      ServiceDataModel(
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
    this.serviceList,
  });

  List<ServiceList>? serviceList;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        serviceList: json["service_list"] == null
            ? null
            : List<ServiceList>.from(
                json["service_list"].map((x) => ServiceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_list": serviceList == null
            ? null
            : List<dynamic>.from(serviceList!.map((x) => x.toJson())),
      };
}

class ServiceList {
  ServiceList({
    this.serviceId,
    this.serviceName,
    this.cityId,
    this.serviceImage,
    this.serviceDetails,
    this.serviceReguPrice,
    this.serviceSalePrice,
    this.catId,
    this.status,
    this.priceId,
    this.amount,
    this.createdDate,
    this.updatedDate,
    this.itemQuantity = 1,
  });

  String? serviceId;
  String? serviceName;
  String? cityId;
  String? serviceImage;
  String? serviceDetails;
  dynamic serviceReguPrice;
  dynamic serviceSalePrice;
  String? catId;
  String? status;
  String? priceId;
  String? amount;
  String? createdDate;
  String? updatedDate;
  int itemQuantity;

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        cityId: json["city_id"],
        serviceImage: json["service_image"],
        serviceDetails: json["service_details"],
        serviceReguPrice: json["service_regu_price"],
        serviceSalePrice: json["service_sale_price"],
        catId: json["cat_id"],
        status: json["status"],
        priceId: json["price_id"],
        amount: json["amount"],
        createdDate: json["created_date"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_name": serviceName,
        "city_id": cityId,
        "service_image": serviceImage,
        "service_details": serviceDetails,
        "service_regu_price": serviceReguPrice,
        "service_sale_price": serviceSalePrice,
        "cat_id": catId,
        "status": status,
        "price_id": priceId,
        "amount": amount,
        "created_date": createdDate,
        "updated_date": updatedDate,
      };
}
