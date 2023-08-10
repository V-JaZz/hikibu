import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Children {
  final int id;
  final int userId;
  final String name;
  final String nickname;
  final String relation;
  final String gender;
  final DateTime dob;
  final int age;
  final String setOfQuestions;
  final String image;
  final DateTime createdAt;

  Children({
    required this.id,
    required this.userId,
    required this.name,
    required this.nickname,
    required this.relation,
    required this.gender,
    required this.dob,
    required this.age,
    required this.setOfQuestions,
    required this.image,
    required this.createdAt,
  });

  //   Map<String, int> calculateAge() {
  //   final now = DateTime.now();
  //   int years = now.year - dob.year;
  //   int months = now.month - dob.month;

  //   if (months < 0) {
  //     years--;
  //     months += 12;
  //   }

  //   return {'years': years, 'months': months};
  // }
  Map<String, int> calculateAge() {
    final now = DateTime.now();
    final difference = now.difference(dob);
    final days = difference.inDays;
    int years = now.year - dob.year;
    int months = now.month - dob.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      nickname: json['nickname'],
      relation: json['relation'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      age: json['age'],
      setOfQuestions: json['set_of_questions'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
