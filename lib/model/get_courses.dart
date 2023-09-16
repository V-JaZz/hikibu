import 'package:http/http.dart' as http;
import 'dart:convert';


class Course {
  int? id;
  String? courseName;
  String? courseDesc;
  int? price;
  String? images;
  List<String>? whatYouGet;
  DateTime? createdAt;
  dynamic youtubelink;

  Course({
    this.id,
    this.courseName,
    this.courseDesc,
    this.price,
    this.images,
    this.whatYouGet,
    this.createdAt,
    this.youtubelink,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    List<String> whatYouGetList = [];
    if (json['whatYouGet'] is List<dynamic>) {
      whatYouGetList = List<String>.from(json['whatYouGet']);
    } else if (json['whatYouGet'] is String) {
      whatYouGetList = (json['whatYouGet'] as String)
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((e) => e.trim())
          .toList();
    }
    return Course(
      id: json["id"],
      courseName: json["courseName"],
      courseDesc: json["courseDesc"],
      price: json["price"],
      images: json["images"],
      whatYouGet: whatYouGetList,
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      youtubelink: json["youtubelink"],
    );
  }
}

Future<List<Course>> fetchCourses() async {
  final url = Uri.parse('http://139.59.68.139:3000/courses/all');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((courseData) => Course.fromJson(courseData)).toList();
  } else {
    throw Exception('Failed to fetch courses');
  }
}

Future<Course> fetchCourseDetail(int courseId) async {
  final url = Uri.parse('http://139.59.68.139:3000/courses/get/$courseId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final dynamic jsonData = jsonDecode(response.body);
    return Course.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch course details');
  }
}
