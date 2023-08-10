// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyQuestion extends StatefulWidget {
  const SurveyQuestion({super.key, required this.title});

  final String title;

  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  final _formKey = GlobalKey<FormState>();
  List<QuestionResult> _questionResults = [];
  final List<Question> _initialData = [
    Question(
      isMandatory: true,
      question: 'Do you like drinking coffee?',
      answerChoices: {
        "Yes": [
          Question(
              singleChoice: false,
              question: "What are the brands that you've tried?",
              answerChoices: {
                "Nestle": null,
                "Starbucks": null,
                "Coffee Day": [
                  Question(
                    question: "Did you enjoy visiting Coffee Day?",
                    isMandatory: true,
                    answerChoices: {
                      "Yes": [
                        Question(
                          question: "Please tell us why you like it",
                        )
                      ],
                      "No": [
                        Question(
                          question: "Please tell us what went wrong",
                        )
                      ],
                    },
                  )
                ],
              })
        ],
        "No": [
          Question(
            question: "Do you like drinking Tea then?",
            answerChoices: {
              "Yes": [
                Question(
                    question: "What are the brands that you've tried?",
                    answerChoices: {
                      "Nestle": null,
                      "ChaiBucks": null,
                      "Indian Premium Tea": [
                        Question(
                          question: "Did you enjoy visiting IPT?",
                          answerChoices: {
                            "Yes": [
                              Question(
                                question: "Please tell us why you like it",
                              )
                            ],
                            "No": [
                              Question(
                                question: "Please tell us what went wrong",
                              )
                            ],
                          },
                        )
                      ],
                    })
              ],
              "No": null,
            },
          )
        ],
      },
    ),
    Question(
        question: "What age group do you fall in?",
        isMandatory: true,
        answerChoices: const {
          "18-20": null,
          "20-30": null,
          "Greater than 30": null,
        })
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Survey(
              onNext: (questionResults) {
                _questionResults = questionResults;
              },
              initialData: _initialData),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(
                      255, 103, 43, 215), // Background Color
                ),
                child: const Text("Validate"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //do something
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> surveyResponseToAPI(List<bool> inputData) async {
  final apiUrl =
      'https://example.com/api'; // Replace with your API endpoint URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': inputData}),
    );

    if (response.statusCode == 200) {
      print('Data stored successfully!');
    } else {
      print('Failed to store data. Error code: ${response.statusCode}');
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Unknown error occurred",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey[300],
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
// call like this
//   List<bool> inputData = [true, false, true];
// surveyResponseToAPI(inputData);
}
