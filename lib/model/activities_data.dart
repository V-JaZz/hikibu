// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';

ActivityModel activityModelFromJson(String str) => ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  Activity? activity;
  List<MaterialData>? materialData;
  List<StepData>? stepData;

  ActivityModel({
    this.activity,
    this.materialData,
    this.stepData,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    activity: json["activity"] == null ? null : Activity.fromJson(json["activity"]),
    materialData: json["materialData"] == null ? [] : List<MaterialData>.from(json["materialData"]!.map((x) => MaterialData.fromJson(x))),
    stepData: json["stepData"] == null ? [] : List<StepData>.from(json["stepData"]!.map((x) => StepData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "activity": activity?.toJson(),
    "materialData": materialData == null ? [] : List<dynamic>.from(materialData!.map((x) => x.toJson())),
    "stepData": stepData == null ? [] : List<dynamic>.from(stepData!.map((x) => x.toJson())),
  };
}

class Activity {
  int? id;
  String? name;
  String? image;
  String? timeDuration;
  dynamic labels;
  dynamic description;

  Activity({
    this.id,
    this.name,
    this.image,
    this.timeDuration,
    this.labels,
    this.description,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    timeDuration: json["time_duration"],
    labels: json["labels"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "time_duration": timeDuration,
    "labels": labels,
    "description": description,
  };
}

class MaterialData {
  int? id;
  int? activityId;
  String? materialName;

  MaterialData({
    this.id,
    this.activityId,
    this.materialName,
  });

  factory MaterialData.fromJson(Map<String, dynamic> json) => MaterialData(
    id: json["id"],
    activityId: json["activity_id"],
    materialName: json["material_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_id": activityId,
    "material_name": materialName,
  };
}

class StepData {
  int? id;
  int? activityId;
  String? stepDescription;
  String? title;
  String? image;

  StepData({
    this.id,
    this.activityId,
    this.stepDescription,
    this.title,
    this.image,
  });

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
    id: json["id"],
    activityId: json["activity_id"],
    stepDescription: json["step_description"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_id": activityId,
    "step_description": stepDescription,
    "title": title,
    "image": image,
  };
}
