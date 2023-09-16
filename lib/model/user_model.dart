// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  dynamic name;
  String? mobile;
  dynamic image;
  DateTime? date;
  dynamic email;
  dynamic relation;
  dynamic age;
  dynamic gender;
  dynamic area;
  dynamic education;
  dynamic vocation;
  dynamic job;

  UserModel({
    this.id,
    this.name,
    this.mobile,
    this.image,
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

  UserModel copyWith({
    int? id,
    dynamic name,
    String? mobile,
    dynamic image,
    DateTime? date,
    dynamic email,
    dynamic relation,
    dynamic age,
    dynamic gender,
    dynamic area,
    dynamic education,
    dynamic vocation,
    dynamic job,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        image: image ?? this.image,
        date: date ?? this.date,
        email: email ?? this.email,
        relation: relation ?? this.relation,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        area: area ?? this.area,
        education: education ?? this.education,
        vocation: vocation ?? this.vocation,
        job: job ?? this.job,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    image: json["image"],
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
