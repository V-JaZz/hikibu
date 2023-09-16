import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildResponse {
  final String childId;
  final int calmHimselfByBringingHandToMouth;
  final int expressEmotionsLikePleasureAndDiscomfort;
  final int tryToLookForHisParent;
  final int recognizeFamilyFaces;
  final int smileAtFamiliarFaces;
  final int respondPositivelyToTouch;
  final int makeGurglingSound;
  final int cryDifferentlyOnDifferentNeed;
  final int tryToImitateSound;
  final int followPeopleWithHisEyes;
  final int followObjectWithHisEyes;
  final int observeFacesWithInterest;
  final int raiseHisHeadLyingOnHisStomach;
  final int bringHisHandToHisMouth;
  final int tryToTouchDanglingObjects;
  final int hasStartedToSmileAtOthers;

  ChildResponse({
    required this.childId,
    required this.calmHimselfByBringingHandToMouth,
    required this.expressEmotionsLikePleasureAndDiscomfort,
    required this.tryToLookForHisParent,
    required this.recognizeFamilyFaces,
    required this.smileAtFamiliarFaces,
    required this.respondPositivelyToTouch,
    required this.makeGurglingSound,
    required this.cryDifferentlyOnDifferentNeed,
    required this.tryToImitateSound,
    required this.followPeopleWithHisEyes,
    required this.followObjectWithHisEyes,
    required this.observeFacesWithInterest,
    required this.raiseHisHeadLyingOnHisStomach,
    required this.bringHisHandToHisMouth,
    required this.tryToTouchDanglingObjects,
    required this.hasStartedToSmileAtOthers,
  });

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'calm_himself_by_bringing_hand_to_mouth':
          calmHimselfByBringingHandToMouth,
      'express_emotions_like_pleasure_and_discomfort':
          expressEmotionsLikePleasureAndDiscomfort,
      'try_to_look_for_his_parent': tryToLookForHisParent,
      'recognize_family_faces': recognizeFamilyFaces,
      'smile_at_familiar_faces': smileAtFamiliarFaces,
      'respond_positively_to_touch': respondPositivelyToTouch,
      'make_gurgling_sound': makeGurglingSound,
      'cry_differently_on_different_need': cryDifferentlyOnDifferentNeed,
      'try_to_imitate_sound': tryToImitateSound,
      'follow_people_with_his_eyes': followPeopleWithHisEyes,
      'follow_object_with_his_eyes': followObjectWithHisEyes,
      'observe_faces_with_interest': observeFacesWithInterest,
      'raise_his_head_lying_on_his_stomach': raiseHisHeadLyingOnHisStomach,
      'bring_his_hand_to_his_mouth': bringHisHandToHisMouth,
      'try_to_touch_dangling_objects': tryToTouchDanglingObjects,
      'has_started_to_smile_at_others': hasStartedToSmileAtOthers,
    };
  }
}

Future<void> sendChildResponse(ChildResponse response) async {
  final url = Uri.parse('https://api.example.com/response');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(response.toJson());

  final http.Response apiResponse =
      await http.post(url, headers: headers, body: body);

  if (apiResponse.statusCode == 200) {
    print('Response sent successfully');
  } else {
    throw Exception('Failed to send response');
  }
}
