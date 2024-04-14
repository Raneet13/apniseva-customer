// To parse this JSON data, do
//
//     final cartDetailsDataModel = cartDetailsDataModelFromJson(jsonString);

import 'dart:convert';

CartDetailsDataModel cartDetailsDataModelFromJson(String str) =>
    CartDetailsDataModel.fromJson(json.decode(str));

String cartDetailsDataModelToJson(CartDetailsDataModel data) =>
    json.encode(data.toJson());

class CartDetailsDataModel {
  final int? status;
  final bool? error;
  final Messages? messages;

  CartDetailsDataModel({
    this.status,
    this.error,
    this.messages,
  });

  factory CartDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      CartDetailsDataModel(
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
  final Status? status;

  Messages({
    this.responsecode,
    this.status,
  });

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
  final List<AllCart>? allCart;
  final TotalAmount? totalAmount;
  final List<AddressDatum>? addressData;

  Status({
    this.allCart,
    this.totalAmount,
    this.addressData,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        allCart: json["All_cart"] == null
            ? []
            : List<AllCart>.from(
                json["All_cart"]!.map((x) => AllCart.fromJson(x))),
        totalAmount: json["Total_amount"] == null
            ? null
            : TotalAmount.fromJson(json["Total_amount"]),
        addressData: json["address_data"] == null
            ? []
            : List<AddressDatum>.from(
                json["address_data"]!.map((x) => AddressDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "All_cart": allCart == null
            ? []
            : List<dynamic>.from(allCart!.map((x) => x.toJson())),
        "Total_amount": totalAmount?.toJson(),
        "address_data": addressData == null
            ? []
            : List<dynamic>.from(addressData!.map((x) => x.toJson())),
      };
}

class AddressDatum {
  final String? addressId;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? cityname;
  final String? state;
  final String? pincode;
  final String? email;
  final String? number;
  final String? address1;
  final String? adress2;
  final String? isDelte;
  final dynamic lat;
  final dynamic lng;
  final DateTime? createdDate;
  final DateTime? updatdDare;
  final String? cityId;
  final String? cityName;
  final String? status;
  final DateTime? updatedDate;

  AddressDatum({
    this.addressId,
    this.userId,
    this.firstName,
    this.lastName,
    this.cityname,
    this.state,
    this.pincode,
    this.email,
    this.number,
    this.address1,
    this.adress2,
    this.isDelte,
    this.lat,
    this.lng,
    this.createdDate,
    this.updatdDare,
    this.cityId,
    this.cityName,
    this.status,
    this.updatedDate,
  });

  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        addressId: json["address_id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        cityname: json["cityname"],
        state: json["state"],
        pincode: json["pincode"],
        email: json["email"],
        number: json["number"],
        address1: json["address1"],
        adress2: json["adress2"],
        isDelte: json["is_delte"],
        lat: json["lat"],
        lng: json["lng"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updatdDare: json["updatd_dare"] == null
            ? null
            : DateTime.parse(json["updatd_dare"]),
        cityId: json["city_id"],
        cityName: json["city_name"],
        status: json["status"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "cityname": cityname,
        "state": state,
        "pincode": pincode,
        "email": email,
        "number": number,
        "address1": address1,
        "adress2": adress2,
        "is_delte": isDelte,
        "lat": lat,
        "lng": lng,
        "created_date": createdDate?.toIso8601String(),
        "updatd_dare": updatdDare?.toIso8601String(),
        "city_id": cityId,
        "city_name": cityName,
        "status": status,
        "updated_date": updatedDate?.toIso8601String(),
      };
}

class AllCart {
  final String? cartId;
  final String? productId;
  final String? parentIdId;
  final String? servicename;
  final String? qty;
  final String? image;
  final String? price;

  AllCart({
    this.cartId,
    this.productId,
    this.parentIdId,
    this.servicename,
    this.qty,
    this.image,
    this.price,
  });

  factory AllCart.fromJson(Map<String, dynamic> json) => AllCart(
        cartId: json["cart_id"],
        productId: json["product_id"],
        parentIdId: json["parent_id_id"],
        servicename: json["servicename"],
        qty: json["qty"],
        image: json["image"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_id": productId,
        "parent_id_id": parentIdId,
        "servicename": servicename,
        "qty": qty,
        "image": image,
        "price": price,
      };
}

class TotalAmount {
  final int? total;

  TotalAmount({
    this.total,
  });

  factory TotalAmount.fromJson(Map<String, dynamic> json) => TotalAmount(
        total: json["Total"],
      );

  Map<String, dynamic> toJson() => {
        "Total": total,
      };
}
