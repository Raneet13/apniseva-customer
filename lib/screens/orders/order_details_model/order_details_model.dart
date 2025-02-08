// To parse this JSON data, do
//
//     final orderDetailDataModel = orderDetailDataModelFromJson(jsonString);

import 'dart:convert';

OrderDetailDataModel orderDetailDataModelFromJson(String str) =>
    OrderDetailDataModel.fromJson(json.decode(str));

String orderDetailDataModelToJson(OrderDetailDataModel data) =>
    json.encode(data.toJson());

class OrderDetailDataModel {
  int? status;
  bool? error;
  Messages? messages;

  OrderDetailDataModel({
    this.status,
    this.error,
    this.messages,
  });

  factory OrderDetailDataModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailDataModel(
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
  String? responsecode;
  Status? status;

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
  List<Rattingdetail>? rattingdetails;
  List<AllOrder>? allOrders;
  List<LOrder>? additinalOrders;
  OtherDtl? otherDtl;
  List<Address>? address;

  Status({
    this.rattingdetails,
    this.allOrders,
    this.additinalOrders,
    this.otherDtl,
    this.address,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        rattingdetails: json["rattingdetails"] == null
            ? []
            : List<Rattingdetail>.from(
                json["rattingdetails"]!.map((x) => Rattingdetail.fromJson(x))),
        allOrders: json["All_orders"] == null
            ? []
            : List<AllOrder>.from(
                json["All_orders"]!.map((x) => AllOrder.fromJson(x))),
        additinalOrders: json["additinal_orders"] == null
            ? []
            : List<LOrder>.from(
                json["additinal_orders"]!.map((x) => LOrder.fromJson(x))),
        otherDtl: json["other_dtl"] == null
            ? null
            : OtherDtl.fromJson(json["other_dtl"]),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rattingdetails": rattingdetails == null
            ? []
            : List<dynamic>.from(rattingdetails!.map((x) => x.toJson())),
        "All_orders": allOrders == null
            ? []
            : List<dynamic>.from(allOrders!.map((x) => x.toJson())),
        "additinal_orders": additinalOrders == null
            ? []
            : List<dynamic>.from(additinalOrders!.map((x) => x.toJson())),
        "other_dtl": otherDtl?.toJson(),
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
      };
}

class LOrder {
  String? productName;
  String? qty;
  String? price;

  LOrder({
    this.productName,
    this.qty,
    this.price,
  });

  factory LOrder.fromJson(Map<String, dynamic> json) => LOrder(
        productName: json["product_name"],
        qty: json["qty"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "qty": qty,
        "price": price,
      };
}

class AllOrder {
  String? productName;
  String? qty;
  String? image;
  String? price;

  AllOrder({
    this.productName,
    this.qty,
    this.image,
    this.price,
  });

  factory AllOrder.fromJson(Map<String, dynamic> json) => AllOrder(
        productName: json["product_name"],
        qty: json["qty"],
        image: json["image"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "qty": qty,
        "image": image,
        "price": price,
      };
}

class Address {
  String? addressId;
  String? userId;
  String? firstName;
  String? lastName;
  String? cityname;
  String? state;
  String? pincode;
  String? email;
  String? number;
  String? address1;
  String? adress2;
  String? isDelte;
  dynamic lat;
  dynamic lng;
  DateTime? createdDate;
  DateTime? updatdDare;
  String? cityId;
  String? cityName;
  String? status;
  DateTime? updatedDate;

  Address({
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

  factory Address.fromJson(Map<String, dynamic> json) => Address(
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

class OtherDtl {
  String? orderId;
  String? status;
  String? bookingDate;
  String? bookingTime;
  String? verifyOtp;
  int? totalPrice;
  String? discount;
  String? gst;
  int? grandTotal;
  int? dueAmount;
  int? paidAmount;
  String? technicianId;

  OtherDtl(
      {this.orderId,
      this.status,
      this.bookingDate,
      this.bookingTime,
      this.verifyOtp,
      this.totalPrice,
      this.discount,
      this.gst,
      this.grandTotal,
      this.dueAmount,
      this.paidAmount,
      this.technicianId});

  OtherDtl.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    status = json['status'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    verifyOtp = json['verify_otp'];
    totalPrice = json['total_price'];
    discount = json['discount'];
    gst = json['gst'];
    grandTotal = json['grand_total'];
    dueAmount = json['due_amount'];
    paidAmount = json['paid_amount'];
    technicianId = json['Technician_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['verify_otp'] = this.verifyOtp;
    data['total_price'] = this.totalPrice;
    data['discount'] = this.discount;
    data['gst'] = this.gst;
    data['grand_total'] = this.grandTotal;
    data['due_amount'] = this.dueAmount;
    data['paid_amount'] = this.paidAmount;
    data['Technician_id'] = this.technicianId;
    return data;
  }
}

class Rattingdetail {
  String? ratingReviewId;
  String? orderId;
  String? fromUserId;
  String? toUserId;
  String? rating;
  String? review;
  String? usertype;
  DateTime? createdDate;

  Rattingdetail({
    this.ratingReviewId,
    this.orderId,
    this.fromUserId,
    this.toUserId,
    this.rating,
    this.review,
    this.usertype,
    this.createdDate,
  });

  factory Rattingdetail.fromJson(Map<String, dynamic> json) => Rattingdetail(
        ratingReviewId: json["rating_review_id"],
        orderId: json["order_id"],
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        rating: json["rating"],
        review: json["review"],
        usertype: json["usertype"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
      );

  Map<String, dynamic> toJson() => {
        "rating_review_id": ratingReviewId,
        "order_id": orderId,
        "from_user_id": fromUserId,
        "to_user_id": toUserId,
        "rating": rating,
        "review": review,
        "usertype": usertype,
        "created_date": createdDate?.toIso8601String(),
      };
}
