import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../API/api_client.dart';
import '../services/storage.dart';

List<Activity> activityFromJson(String str) => List<Activity>.from(json.decode(str).map((x) => Activity.fromJson(x)));

String activityToJson(List<Activity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activity {
  int? childActivityId;
  int? childId;
  int? activityId;
  int? isCompleted;
  int? favorite;
  DateTime? dateAdded;
  DateTime? dateCompleted;
  int? id;
  String? name;
  String? image;
  String? timeDuration;

  Activity({
    this.childActivityId,
    this.childId,
    this.activityId,
    this.isCompleted,
    this.favorite,
    this.dateAdded,
    this.dateCompleted,
    this.id,
    this.name,
    this.image,
    this.timeDuration,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    childActivityId: json["child_activity_id"],
    childId: json["child_id"],
    activityId: json["activity_id"],
    isCompleted: json["is_completed"],
    favorite: json["favorite"],
    dateAdded: json["date_added"] == null ? null : DateTime.parse(json["date_added"]),
    dateCompleted: json["date_completed"] == null ? null : DateTime.parse(json["date_completed"]),
    id: json["id"],
    name: json["name"],
    image: json["image"],
    timeDuration: json["time_duration"],
  );

  Map<String, dynamic> toJson() => {
    "child_activity_id": childActivityId,
    "child_id": childId,
    "activity_id": activityId,
    "is_completed": isCompleted,
    "favorite": favorite,
    "date_added": dateAdded?.toIso8601String(),
    "date_completed": dateCompleted?.toIso8601String(),
    "id": id,
    "name": name,
    "image": image,
    "time_duration": timeDuration,
  };
}


Future<List<Activity>> fetchActivities() async {
  String? selectedChild = StorageService.to.getString('selectedChild');
  if(selectedChild != ''){

    Response response = await ApiClient.to.getData(
        'http://13.127.11.171:3000/activities-child/1'
    );
    print(response.statusCode);
    print(response.body["data"].toString());
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.body["data"];
      return jsonData
          .map((activityData) => Activity.fromJson(activityData))
          .toList();
    } else {
      throw Exception('Failed to fetch activities');
    }

  }else{

    final url = Uri.parse('http://13.127.11.171:3000/allActivity');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((activityData) => Activity.fromJson(activityData))
          .toList();
    } else {
      throw Exception('Failed to fetch activities');
    }
  }
}
