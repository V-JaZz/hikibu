import 'package:http/http.dart' as http;
import 'dart:convert';

class Course {
  final int id;
  final String courseName;
  final String courseDesc;
  final String instructorOccupation;
  final String instructorName;
  final String instructorDesc;
  final String price;
  final String whatYouGet;

  Course({
    required this.id,
    required this.courseName,
    required this.courseDesc,
    required this.instructorOccupation,
    required this.instructorName,
    required this.instructorDesc,
    required this.price,
    required this.whatYouGet,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseName: json['courseName'],
      courseDesc: json['courseDesc'],
      instructorOccupation: json['instructorOccupation'],
      instructorName: json['instructorName'],
      instructorDesc: json['instructorDesc'],
      price: json['price'],
      whatYouGet: json['whatYouGet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'courseDesc': courseDesc,
      'instructorOccupation': instructorOccupation,
      'instructorName': instructorName,
      'instructorDesc': instructorDesc,
      'price': price,
      'whatYouGet': whatYouGet,
    };
  }
}

Future<void> postCourseData(Course course) async {
  final url = Uri.parse('https://api.example.com/courses');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(course.toJson());

  final http.Response apiResponse =
      await http.post(url, headers: headers, body: body);

  if (apiResponse.statusCode == 200) {
    print('Course data posted successfully');
  } else {
    throw Exception('Failed to post course data');
  }
}
