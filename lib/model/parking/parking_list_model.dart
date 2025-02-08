// To parse this JSON data, do
//
//     final parkingModel = parkingModelFromJson(jsonString);

import 'dart:convert';

ParkingModel parkingModelFromJson(String str) => ParkingModel.fromJson(json.decode(str));

String parkingModelToJson(ParkingModel data) => json.encode(data.toJson());

class ParkingModel {
    bool? success;
    String? message;
    List<Datum>? data;

    ParkingModel({
        this.success,
        this.message,
        this.data,
    });

    factory ParkingModel.fromJson(Map<String, dynamic> json) => ParkingModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? parkingId;
    String? parkingName;
    int? parkingCapacity;
    int? parkingVehicleCount;
    String? parkingTime;
    String? parkingLocation;
    String? parkingPhoneNumber;
    String? createdAt;
    List<ParkingPriceDatum>? parkingPriceData;

    Datum({
        this.parkingId,
        this.parkingName,
        this.parkingCapacity,
        this.parkingVehicleCount,
        this.parkingTime,
        this.parkingLocation,
        this.parkingPhoneNumber,
        this.createdAt,
        this.parkingPriceData,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        parkingId: json["parking_id"],
        parkingName: json["parking_name"],
        parkingCapacity: json["parking_capacity"],
        parkingVehicleCount: json["parking_vehicle_count"],
        parkingTime: json["parking_time"],
        parkingLocation: json["parking_location"],
        parkingPhoneNumber: json["parking_phone_number"],
        createdAt: json["created_at"],
        parkingPriceData: json["parking_price_data"] == null ? [] : List<ParkingPriceDatum>.from(json["parking_price_data"]!.map((x) => ParkingPriceDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "parking_id": parkingId,
        "parking_name": parkingName,
        "parking_capacity": parkingCapacity,
        "parking_vehicle_count": parkingVehicleCount,
        "parking_time": parkingTime,
        "parking_location": parkingLocation,
        "parking_phone_number": parkingPhoneNumber,
        "created_at": createdAt,
        "parking_price_data": parkingPriceData == null ? [] : List<dynamic>.from(parkingPriceData!.map((x) => x.toJson())),
    };
}

class ParkingPriceDatum {
    int? id;
    int? parkingDataId;
    int? time;
    int? subscriptionPrice;
    int? nonSubscriptionPrice;
    String? createdAt;
    String? updatedAt;

    ParkingPriceDatum({
        this.id,
        this.parkingDataId,
        this.time,
        this.subscriptionPrice,
        this.nonSubscriptionPrice,
        this.createdAt,
        this.updatedAt,
    });

    factory ParkingPriceDatum.fromJson(Map<String, dynamic> json) => ParkingPriceDatum(
        id: json["id"],
        parkingDataId: json["parking_data_id"],
        time: json["time"],
        subscriptionPrice: json["subscription_price"],
        nonSubscriptionPrice: json["non_subscription_price"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parking_data_id": parkingDataId,
        "time": time,
        "subscription_price": subscriptionPrice,
        "non_subscription_price": nonSubscriptionPrice,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
