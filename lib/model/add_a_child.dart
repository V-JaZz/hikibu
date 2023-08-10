import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class AddAChild {
  final File childImage;
  final String name;
  final String nickname;
  final String relation;
  final String gender;
  final String dob;
  final String age;
  final List<bool> questions;
  String get childImageBase64 {
    if (childImage == null) return '';
    List<int> imageBytes = childImage.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  AddAChild({
    required this.childImage,
    required this.name,
    required this.nickname,
    required this.relation,
    required this.gender,
    required this.dob,
    required this.age,
    required this.questions,
  });

  // factory AddAChild.fromJson(Map<String, dynamic> json) {
  //   return AddAChild(
  //     childImage: json['childImage'],
  //     name: json['name'],
  //     nickname: json['nickname'],
  //     relation: json['relation'],
  //     gender: json['gender'],
  //     dob: json['dob'],
  //     age: json['age'],
  //     questions: List<bool>.from(json['questions']),
  //   );
  // }
  factory AddAChild.fromJson(Map<String, dynamic> json) {
    // ... other properties remain the same
    final decodedImage = base64Decode(json['childImage'] ?? '');
    final tempImagePath = Directory.systemTemp.path + '/temp_image.jpg';
    File(tempImagePath).writeAsBytesSync(decodedImage);
    return AddAChild(
      childImage: File(tempImagePath),

      name: json['name'],
      nickname: json['nickname'],
      relation: json['relation'],
      gender: json['gender'],
      dob: json['dob'],
      age: json['age'],
      questions: List<bool>.from(json['questions']),
      // ... other properties remain the same
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'childImage': childImage,
      'childImage': childImageBase64,
      'name': name,
      'nickname': nickname,
      'relation': relation,
      'gender': gender,
      'dob': dob,
      'age': age,
      'questions': questions,
    };
  }
}

// postChildData(AddAChild childData) async {
//   var request = http.MultipartRequest(
//       'POST', Uri.parse('http://13.126.205.178:3000/addChild/1'));
//   request.fields.addAll({
//     'name': childData.name,
//     'nickname': childData.nickname,
//     'relation': childData.relation,
//     'gender': childData.gender,
//     'dob': childData.dob,
//     'age': childData.age,
//     'questions': childData.questions.toString(),
//   });
//   request.files.add(await http.MultipartFile.fromPath(
//       'childImage', childData.childImage.path));

//   http.StreamedResponse response = await request.send();

//   print('hellp woplf');

//   if (response.statusCode == 200) {
//     print('Child data posted successfully');
//   }
// }

// Future<void> postChildData(AddAChild childData) async {
//   var request = http.MultipartRequest(
//       'POST', Uri.parse('http://13.126.205.178:3000/addChild/1'));

//   // Set the fields
//   request.fields['name'] = childData.name;
//   request.fields['nickname'] = childData.nickname;
//   request.fields['relation'] = childData.relation;
//   request.fields['gender'] = childData.gender;
//   request.fields['dob'] = childData.dob;
//   request.fields['age'] = childData.age;
//   request.fields['questions'] = childData.questions.toString();

//   // Set the child image
//   request.files.add(await http.MultipartFile.fromPath(
//       'childImage', childData.childImage.path));

//   http.StreamedResponse response = await request.send();

//   print('hello world');

//   if (response.statusCode == 200) {
//     print('Child data posted successfully');
//   }
// }



// Future<void> postChildData(AddAChild childData) async {
//   final url = Uri.parse('http://13.126.205.178:3000/addChild/1');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode(childData.toJson());

//   final http.Response apiResponse =
//       await http.post(url, headers: headers, body: body);

//   if (apiResponse.statusCode == 200) {
//     print('Child data posted successfully');
//   } else {
//     throw Exception('Failed to post child data');
//   }
// }




// class AddAChild {
//   final String parentId;
//   final String name;
//   final String nickName;
//   final String DOB;
//   final int relation;
//   final int gender;

//   final int calmHimselfByBringingHandToMouth;
//   final int expressEmotionsLikePleasureAndDiscomfort;
//   final int tryToLookForHisParent;
//   final int recognizeFamilyFaces;
//   final int smileAtFamiliarFaces;
//   final int respondPositivelyToTouch;
//   final int makeGurglingSound;
//   final int cryDifferentlyOnDifferentNeed;
//   final int tryToImitateSound;
//   final int followPeopleWithHisEyes;
//   final int followObjectWithHisEyes;
//   final int observeFacesWithInterest;
//   final int raiseHisHeadLyingOnHisStomach;
//   final int bringHisHandToHisMouth;
//   final int tryToTouchDanglingObjects;
//   final int hasStartedToSmileAtOthers;

//   AddAChild({
//     required this.parentId,
//     required this.name,
//     required this.nickName,
//     required this.DOB,
//     required this.relation,
//     required this.gender,
//     required this.calmHimselfByBringingHandToMouth,
//     required this.expressEmotionsLikePleasureAndDiscomfort,
//     required this.tryToLookForHisParent,
//     required this.recognizeFamilyFaces,
//     required this.smileAtFamiliarFaces,
//     required this.respondPositivelyToTouch,
//     required this.makeGurglingSound,
//     required this.cryDifferentlyOnDifferentNeed,
//     required this.tryToImitateSound,
//     required this.followPeopleWithHisEyes,
//     required this.followObjectWithHisEyes,
//     required this.observeFacesWithInterest,
//     required this.raiseHisHeadLyingOnHisStomach,
//     required this.bringHisHandToHisMouth,
//     required this.tryToTouchDanglingObjects,
//     required this.hasStartedToSmileAtOthers,

//     // required this.childImage,
//     // required this.name,
//     //     required this.nickname,
//     //         required this.relation,
//     //             required this.gender,
//     //                 required this.dob,
//     //                     required this.age,
//   });

//   factory AddAChild.fromJson(Map<String, dynamic> json) {
//     return AddAChild(
//       parentId: json['parentId'],
//       name: json['name'],
//       nickName: json['nickName'],
//       DOB: json['DOB'],
//       relation: json['relation'],
//       gender: json['gender'],
//       calmHimselfByBringingHandToMouth:
//           json['calm_himself_by_bringing_hand_to_mouth'],
//       expressEmotionsLikePleasureAndDiscomfort:
//           json['express_emotions_like_pleasure_and_discomfort'],
//       tryToLookForHisParent: json['try_to_look_for_his_parent'],
//       recognizeFamilyFaces: json['recognize_family_faces'],
//       smileAtFamiliarFaces: json['smile_at_familiar_faces'],
//       respondPositivelyToTouch: json['respond_positively_to_touch'],
//       makeGurglingSound: json['make_gurgling_sound'],
//       cryDifferentlyOnDifferentNeed: json['cry_differently_on_different_need'],
//       tryToImitateSound: json['try_to_imitate_sound'],
//       followPeopleWithHisEyes: json['follow_people_with_his_eyes'],
//       followObjectWithHisEyes: json['follow_object_with_his_eyes'],
//       observeFacesWithInterest: json['observe_faces_with_interest'],
//       raiseHisHeadLyingOnHisStomach:
//           json['raise_his_head_lying_on_his_stomach'],
//       bringHisHandToHisMouth: json['bring_his_hand_to_his_mouth'],
//       tryToTouchDanglingObjects: json['try_to_touch_dangling_objects'],
//       hasStartedToSmileAtOthers: json['has_started_to_smile_at_others'],
//     );
//   }
// }

// Future<AddAChild> postAChildData() async {
//   final response =
//       await http.get(Uri.parse('http://13.126.205.178:3000/addChild/1'));

//   if (response.statusCode == 200) {
//     final jsonData = jsonDecode(response.body);
//     return AddAChild.fromJson(jsonData);
//   } else {
//     throw Exception('Failed to fetch child data');
//   }
// }
