// To parse this JSON data, do
//
//     final subCategoryDataModel = subCategoryDataModelFromJson(jsonString);

import 'dart:convert';

SubCategoryDataModel subCategoryDataModelFromJson(String str) => SubCategoryDataModel.fromJson(json.decode(str));

String subCategoryDataModelToJson(SubCategoryDataModel data) => json.encode(data.toJson());

class SubCategoryDataModel {
  SubCategoryDataModel({
    this.status,
    this.error,
    this.messages,
  });

  int? status;
  bool? error;
  Messages? messages;

  factory SubCategoryDataModel.fromJson(Map<String, dynamic> json) => SubCategoryDataModel(
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
    this.categoryDtl,
  });

  List<CategoryDtl>? categoryDtl;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    categoryDtl: json["category_dtl"] == null ? [] : List<CategoryDtl>.from(json["category_dtl"]!.map((x) => CategoryDtl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category_dtl": categoryDtl == null ? [] : List<dynamic>.from(categoryDtl!.map((x) => x.toJson())),
  };
}

class CategoryDtl {
  CategoryDtl({
    this.catId,
    this.catName,
    this.parentId,
    this.cityIds,
    this.catImg,
    this.status,
    this.createdDate,
    this.subcat,
  });

  String? catId;
  String? catName;
  String? parentId;
  String? cityIds;
  String? catImg;
  String? status;
  String? createdDate;
  int? subcat;

  factory CategoryDtl.fromJson(Map<String, dynamic> json) => CategoryDtl(
    catId: json["cat_id"],
    catName: json["cat_name"],
    parentId: json["parent_id"],
    cityIds: json["city_ids"],
    catImg: json["cat_img"],
    status: json["status"],
    createdDate: json["created_date"],
    subcat: json["subcat"],
  );

  Map<String, dynamic> toJson() => {
    "cat_id": catId,
    "cat_name": catName,
    "parent_id": parentId,
    "city_ids": cityIds,
    "cat_img": catImg,
    "status": status,
    "created_date": createdDate,
    "subcat": subcat,
  };
}
