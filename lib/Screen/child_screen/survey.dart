// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable, duplicate_ignore, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/components/survey_question.dart';
import 'package:hukibu/model/add_a_child.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../model/survey_quest_model.dart';
import '../../services/storage.dart';

class ReSurvey extends StatefulWidget {
  final String childId;
  const ReSurvey({Key? key, required this.childId}) : super(key: key);

  @override
  ReSurveyState createState() => ReSurveyState();
}

class ReSurveyState extends State<ReSurvey> {

  late String selectedGender = '';
  late String selectedRelation = '';
  late DateTime selectedDate;

  TextEditingController fullName = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController gender = TextEditingController();

  String? imageURL;
  File? _image;
  final picker = ImagePicker();
  String? name;
  String? pdf;

  SurveyQuestModel surveyQuestModel = SurveyQuestModel();

  postChild() async {

    try{
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://139.59.68.139:3000/admin-updateChild/${widget.childId}'));
      request.fields.addAll({
        'questions': List<dynamic>.from(surveyQuestModel.data!.map((x) => x.toJson())).toString(),
      }) ;
      print(request.toString());
      print(request.fields.toString());

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      print(response.reasonPhrase);


      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('success');
        Get.back();
        Fluttertoast.showToast(
          msg: "Updated Survey Questions!".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
          fontSize: 16.0,
        );
        return true;
      } else {
        print(response.reasonPhrase);
        Fluttertoast.showToast(
          msg: "${response.statusCode} : ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
          fontSize: 16.0,
        );
        return false;
      }
    }catch (error) {
      print(error);
      Get.snackbar(
        "Auth Failed".tr(),
        '$error',
        snackStyle: SnackStyle.FLOATING,
        icon: const Icon(
          Icons.person,
          color: Color(0xff28282B),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[200],
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        colorText: const Color(0xff28282B),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  bool adding = false;
  bool loading = true;

  @override
  void initState() {
    getSurveyQuest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 90, 32, 100),
        title: Text(
          'Survey Questions'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
            builder: (context) {
              if(loading == true){
                return Center(child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    10.heightBox,
                    const Text('Please wait...')
                  ],
                ));
              }else if(surveyQuestModel.success == false){
                return const Center(child: Text('error!'));
              }else {
                List<QuestAns> questAns = surveyQuestModel.data??[];
                return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  children: [
                    Column(
                        children: questAns.map((questAns) {

                          final String question = questAns.question??'';
                          bool response = questAns.answer??false;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: response
                                      ? const Color.fromARGB(255, 103, 43, 215)
                                      : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: SwitchListTile(
                                activeColor: const Color.fromARGB(255, 103, 43, 215),
                                title: Text(question),
                                value: response,
                                onChanged: (value) {
                                  setState(() {
                                    surveyQuestModel.data![surveyQuestModel.data!.indexOf(questAns)].answer = value;
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList()
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed:postChild,
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 90, 32, 100))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(loading?'Please Wait'.tr():'Submit'.tr()),
                        ))
                  ],
                );
              }
            }),
      ),
    );
  }

  Future<SurveyQuestModel> getSurveyQuest() async {

    var response = await http.get(Uri.parse('http://139.59.68.139:3000/admin-get-all-survey'));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      surveyQuestModel = surveyQuestModelFromJson(response.body);
    }
    else {
      print(response.reasonPhrase);
      surveyQuestModel = SurveyQuestModel(success: false);
    }
    return surveyQuestModel;
  }
}
