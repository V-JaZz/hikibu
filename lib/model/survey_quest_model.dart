// To parse this JSON data, do
//
//     final surveyQuestModel = surveyQuestModelFromJson(jsonString);

import 'dart:convert';

SurveyQuestModel surveyQuestModelFromJson(String str) => SurveyQuestModel.fromJson(json.decode(str));

String surveyQuestModelToJson(SurveyQuestModel data) => json.encode(data.toJson());

class SurveyQuestModel {
  bool? success;
  List<QuestAns>? data;

  SurveyQuestModel({
    this.success,
    this.data,
  });

  factory SurveyQuestModel.fromJson(Map<String, dynamic> json) => SurveyQuestModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<QuestAns>.from(json["data"]!.map((x) => QuestAns.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuestAns {
  int? id;
  String? question;
  bool? answer;

  QuestAns({
    this.id,
    this.question,
    this.answer,
  });

  factory QuestAns.fromJson(Map<String, dynamic> json) => QuestAns(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}
