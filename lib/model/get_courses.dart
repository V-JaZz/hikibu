import 'package:http/http.dart' as http;
import 'dart:convert';

class Course {
  final int id;
  final String courseName;
  final String courseDesc;
  final int price;
  final String images;
  final String whatYouGet;

  final String createdAt;

  Course({
    required this.id,
    required this.courseName,
    required this.courseDesc,
    required this.price,
    required this.images,
    required this.whatYouGet,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseName: json['courseName'],
      courseDesc: json['courseDesc'],
      price: json['price'],
      images: json['images'],
      whatYouGet: json['whatYouGet'],
      createdAt: json['createdAt'],
    );
  }
}

Future<List<Course>> fetchCourses() async {
  final url = Uri.parse('http://13.127.11.171:3000/courses/all');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((courseData) => Course.fromJson(courseData)).toList();
  } else {
    throw Exception('Failed to fetch courses');
  }
}

Future<Course> fetchCourseDetail(int courseId) async {
  final url = Uri.parse('http://13.127.11.171:3000/courses/get/$courseId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final dynamic jsonData = jsonDecode(response.body);
    return Course.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch course details');
  }
}
