
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hukibu/services/user.dart';

import '../model/chat_room_model/chat_room_model.dart';
import '../model/user_model.dart';

class FirebaseFireStore extends GetxController {

  static FirebaseFireStore get to => Get.find();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> addUser(UserModel user) async {
    await fireStore.collection("Users").doc(user.id.toString()).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await fireStore.collection("Users").doc(uid).get();
    return doc.exists ? UserModel.fromJson(doc.data()!) : null;
  }

  Stream<QuerySnapshot> getAllUsers() {
    return fireStore
        .collection("Users")
        .where("uid", isNotEqualTo: UserStore.to.uid)
        .snapshots();
  }

  Future<void> updateUserData(UserModel user) async {
    await fireStore.collection("Users").doc(user.id.toString()).update(user.toJson());
    await UserStore.to.getProfile();
  }

  Future<void> sendMessage(Map<String, dynamic> messageContent, String chatRoomId) async {
    log('Sending1');
    await fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection("chatList")
        .doc()
        .set(messageContent);

    log('Sending');
  }

  Future<void> updateMessage(
      Map<String, dynamic> lastMessage, String chatRoomId) async {
    return await fireStore
        .collection('chats')
        .doc(chatRoomId)
        .update(lastMessage);
  }

  Stream<QuerySnapshot> readMessage(String docId) {
    return fireStore
        .collection("chats")
        .doc(docId)
        .collection("chatList")
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRoom() {
    return fireStore
        .collection("chats")
        .where("users", arrayContains: UserStore.to.uid)
        .where("lastMessage", isNotEqualTo: '')
        .orderBy("lastMessage", descending: false)
        .orderBy("lastMessageTm", descending: true)
        .snapshots();
  }

  Future<void> createChatRoom(ChatRoomModel chatRoom) async {
    final doc =
    await fireStore.collection("chats").doc(chatRoom.chatRoomId).get();
    if (!doc.exists) {
      await fireStore
          .collection("chats")
          .doc(chatRoom.chatRoomId)
          .set(chatRoom.toJson());
    }
  }


}