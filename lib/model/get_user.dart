// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int? id;
  String? name;
  String? mobile;
  String? image;
  int? otp;
  int? otpverify;
  DateTime? date;
  dynamic email;
  dynamic relation;
  int? age;
  String? gender;
  String? area;
  String? education;
  String? vocation;
  String? job;

  UserData({
    this.id,
    this.name,
    this.mobile,
    this.image,
    this.otp,
    this.otpverify,
    this.date,
    this.email,
    this.relation,
    this.age,
    this.gender,
    this.area,
    this.education,
    this.vocation,
    this.job,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    image: json["image"],
    otp: json["otp"],
    otpverify: json["otpverify"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    email: json["email"],
    relation: json["relation"],
    age: json["age"],
    gender: json["gender"],
    area: json["area"],
    education: json["education"],
    vocation: json["vocation"],
    job: json["job"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "image": image,
    "otp": otp,
    "otpverify": otpverify,
    "date": date?.toIso8601String(),
    "email": email,
    "relation": relation,
    "age": age,
    "gender": gender,
    "area": area,
    "education": education,
    "vocation": vocation,
    "job": job,
  };
}
