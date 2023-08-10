import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../services/firebase.dart';
import 'chat_space_state.dart';


class ChatSpaceController extends GetxController{
  final state = ChatSpaceState();
  ChatSpaceController();
  final textController = TextEditingController();
  final msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();

  late types.User user;

  @override
  void onInit() {
    super.onInit();
    var chatData = Get.parameters;
    state.chatRoomId.value = chatData['chatRoomId']?? '';
    state.toUserProfile.value = chatData['toUserProfile']?? '';
    state.toUserName.value = chatData['toUserName']?? '';
    state.toUserUid.value = chatData['toUserUid']?? '';
    state.toUserProfile.value = chatData['toUserProfile']?? '';
    state.toUserName.value = chatData['toUserName']?? '';
    state.toUserUid.value = chatData['toUserUid']?? '';
    loadMessages();
    user = types.User(
      id: state.toUserUid.value,
      firstName: state.toUserName.value,
      imageUrl: state.toUserProfile.value,
    );
  }

  // sendMessage() async {
  //   String sendContent = textController.text.trim();
  //   textController.clear();
  //   if(sendContent != ''){
  //     final content = ChatSpaceModel(
  //       message: sendContent,
  //       sendBy: state.toUserUid.value,
  //       messageTm: DateTime.now(),
  //       sendByPhoto: UserStore.to.profile.image?? '',
  //     );
  //     await FirebaseFireStore
  //         .to.sendMessage(
  //         content.toJson(), state.chatRoomId.value
  //     ).then((value) {
  //       Get.focusScope?.unfocus();
  //     });
  //     log(content.messageTm.toIso8601String());
  //     await FirebaseFireStore.to.updateMessage(
  //         {
  //           "lastMessage": sendContent.trim(),
  //           "lastMessageBy": state.toUserUid.value,
  //           "lastMessageTm": content.messageTm.toIso8601String()
  //         },
  //         state.chatRoomId.value
  //     );
  //   }
  // }

  @override
  void dispose() {
    msgScrolling.dispose();
    super.dispose();
  }

  void handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: Get.context!,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          state.chatData.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (state.chatData[index] as types.FileMessage).copyWith(
            isLoading: true,
          );
          state.chatData[index] = updatedMessage;
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          //  final documentsDir = (await getApplicationDocumentsDirectory()).path;
          //  localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = state.chatData.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (state.chatData[index] as types.FileMessage).copyWith(
            isLoading: null,
          );
          state.chatData[index] = updatedMessage;
        }
      }
      //  await OpenFilex.open(localPath);
    }
  }

  void handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData,) {
    final index = state.chatData.indexWhere((element) => element.id == message.id);
    final updatedMessage = (state.chatData[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    state.chatData[index] = updatedMessage;
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    log('hgsrbi');
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '',
      text: message.text,
    );
    await FirebaseFireStore.to.sendMessage(
      textMessage.toJson(),
      state.chatRoomId.value,
    );
    log('Message Sent.');
    Get.focusScope?.unfocus();
  }

  void loadMessages() async {
    var messages = FirebaseFireStore.to.readMessage(state.chatRoomId.value);
    state.chatData.clear();
    messages.listen((snapshot) {
      log('Hello reading messages : ${snapshot.docs}');
      for (var change in snapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added :
            if (change.doc.data() != null) {
              log('Hello reading messages : ${change.doc.data()}');
              state.chatData.insert(
                0,
                types.Message.fromJson(change.doc.data() as Map<String, Object?>),
              );
            }
            break;
          case DocumentChangeType.modified: break;
          case DocumentChangeType.removed: break;

          default: break;
        }
      }
    },onError: (error) => log("Listening failed: $error"));

    Iterable inReverse = state.chatData.reversed;
    state.chatData.value = inReverse.toList() as List<types.Message>;

  }
}