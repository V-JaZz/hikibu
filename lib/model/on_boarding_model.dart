// To parse this JSON data, do
//
//     final onBoardingModel = onBoardingModelFromJson(jsonString);

import 'dart:convert';

OnBoardingModel onBoardingModelFromJson(String str) => OnBoardingModel.fromJson(json.decode(str));

String onBoardingModelToJson(OnBoardingModel data) => json.encode(data.toJson());

class OnBoardingModel {
  bool? success;
  List<Datum>? data;

  OnBoardingModel({
    this.success,
    this.data,
  });

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) => OnBoardingModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? description;
  String? image;

  Datum({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
  };
}
