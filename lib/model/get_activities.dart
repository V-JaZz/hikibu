// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

List<Activity> activityFromJson(String str) => List<Activity>.from(json.decode(str).map((x) => Activity.fromJson(x)));

String activityToJson(List<Activity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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



Future<List<Activity>> fetchActivities() async {
  // if(selectedChild != '' && !viewAll){
  //
  //   Response response = await ApiClient.to.getData(
  //       'http://139.59.68.139:3000/activities-child/1'
  //   );
  //   print(response.statusCode);
  //   print(response.body["data"].toString());
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = response.body["data"];
  //     return jsonData
  //         .map((activityData) => Activity.fromJson(activityData))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to fetch activities');
  //   }
  //
  // }else{

    final url = Uri.parse('http://139.59.68.139:3000/allActivity');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((activityData) => Activity.fromJson(activityData))
          .toList();
    } else {
      throw Exception('Failed to fetch activities');
    }
  // }
}
