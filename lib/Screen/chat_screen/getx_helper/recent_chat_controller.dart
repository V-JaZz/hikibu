import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../services/firebase.dart';
import '../../../../services/user.dart';
import '../../../model/chat_room_model/chat_room_model.dart';
import '../../../model/get_children.dart';
import '../../../services/storage.dart';
import '../../chat_list.dart';
import 'recent_chat_state.dart';
import 'package:http/http.dart' as http;

class RecentChatController extends GetxController {
  final state = RecentChatState();
  var index = 0.obs;
  RxList<Children> users = <Children>[].obs;
  final myUserId = UserStore.to.uid;
  var isLoading = false.obs;
  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  Future<void> onInit() async {
    print("init");
    super.onInit();
  }
  onRefreshLoadChildren() {
    fetchChildren().then(
            (_) => refreshController.refreshCompleted(resetFooterState: true));
  }
  Future<void> fetchChildren() async {
    try{
      isLoading.value = true;
      final response = await http.get(
          Uri.parse('http://139.59.68.139:3000/getChildById/${StorageService.to.getString('userIdKey')}')); // Replace with your API endpoint
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        final dataList = jsonData.map((item) => Children.fromJson(item)).toList();
        users.value = dataList;
        isLoading.value = false;
      } else {
        isLoading.value = false;
        throw Exception('Failed to fetch data');
      }
    }catch(e){
      log(e.toString());
      isLoading.value = false;
    }
  }

  // asyncLoadData() async {
  //   // isLoading.value = true;
  //   var chatRoomList = FirebaseFireStore.to.getChatRoom();
  //   chatRoomList.listen((snapshot) async {
  //     // isLoading.value = true;
  //     log('Loading');
  //     for (var chatRoom in snapshot.docChanges) {
  //       switch (chatRoom.type) {
  //         case DocumentChangeType.added:
  //           if (chatRoom.doc.data() != null) {
  //             Map<String, dynamic> chatRoomData = chatRoom.doc.data() as Map<String, dynamic>;
  //             state.chatRoomList.add(
  //                 ChatRoomModel.fromJson(chatRoomData)
  //             );
  //             if(chatRoomData['users'][0] == myUserId){
  //               state.otherUser.add(
  //                   (await FirebaseFireStore.to.getUser(chatRoomData['users'][1]))!
  //               );
  //             }else{
  //               state.otherUser.add(
  //                   (await FirebaseFireStore.to.getUser(chatRoomData['users'][0]))!
  //               );
  //             }
  //           }
  //           break;
  //         case DocumentChangeType.modified:
  //           if (chatRoom.doc.data() != null) {
  //             log('This is the change: ${chatRoom.doc.data()}');
  //             Map<String, dynamic> chatRoomData = chatRoom.doc.data() as Map<String, dynamic>;
  //             int changeIndex = state.chatRoomList.indexWhere((element) => element.chatRoomId == chatRoomData['chatRoomId']);
  //             state.chatRoomList[changeIndex] = state.chatRoomList[changeIndex].copyWith(
  //               lastMessage: chatRoomData['lastMessage'],
  //               lastMessageBy: chatRoomData['lastMessageBy'],
  //               lastMessageTm: DateTime.parse(chatRoomData['lastMessageTm']),
  //             );
  //             log('This is update: ${state.chatRoomList}');
  //           }
  //           break;
  //         case DocumentChangeType.removed:
  //           break;
  //       }
  //     }
  //     // isLoading.value = false;
  //     log('Loading completed');
  //   }, onError: (error) => log("Listening failed: $error"));
  // }


  createChatRoom(ChatRoomModel chatRoomModel, Children otherUser) async {
    await FirebaseFireStore.to.createChatRoom(chatRoomModel);
    Get.toNamed(ChatPage.routeName, parameters: {
      "chatRoomId": chatRoomModel.chatRoomId,
      "toUserProfile": otherUser.image?? '',
      "toUserName": otherUser.name?? '',
      "toUserUid": otherUser.id.toString()?? ''
    });
  }

  generateChatRoomId(String myUserUid, String otherUserId) {
    if (myUserUid.substring(0, 1).codeUnitAt(0) >
        otherUserId.substring(0, 1).codeUnitAt(0)) {
      return "$otherUserId\_$myUserUid";
    } else {
      return "$myUserUid\_$otherUserId";
    }
  }
}
