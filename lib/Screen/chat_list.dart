import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hukibu/Screen/chat_screen/getx_helper/chat_space_helper/chat_space_controller.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/model/get_children.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

import '../model/chat_room_model/chat_room_model.dart';
import '../services/user.dart';
import 'add_new_child.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'dart:convert';


import 'chat_screen/getx_helper/recent_chat_controller.dart';

class ChatListScreen extends GetView<RecentChatController> {
  const ChatListScreen({super.key});

  // late Future<List<Children>> _futureDataList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 36,right: 24),
                child: IconButton(onPressed: (){
                  Get.defaultDialog(
                    title: 'Confirm Exit App?',
                    content: const SizedBox.shrink(),
                    titlePadding: const EdgeInsets.only(top: 8),
                    onCancel: () => Get.back(),
                    buttonColor: Colors.indigo,
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      exit(0);
                    },
                  );
                },
                    icon: const Icon(Icons.exit_to_app_rounded,color: Colors.black)),
              ),
            ),
            20.heightBox,
            ListTile(
              title: const Text("settings").tr(),
              leading: CircleAvatar(
                  radius: 13,
                  backgroundColor:
                  const Color.fromARGB(255, 239, 238, 235),
                  child: ClipOval(
                    child:
                    Image.asset('assets/images/empty.webp'),
                  ),
                ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SettingScreen()));
              },
            ),
            20.heightBox,
            ListTile(
              title: const Text("refer to a friend").tr(),
              leading: const Icon(
                Icons.send_sharp,
                color: Colors.black,
              ),
              onTap: () {
                String linkToShare = 'Try this amazing app https://www.example.com - use my referral 1123456';
                Share.share(linkToShare);
              },
            ),
            20.heightBox,
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) => const AddNewChild(),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AddANewChild(),
                        ),
                      );
                    },
                    child: const Text(
                      "add another child",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title:  const Text(
          'Aybala',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: Icon(
              Icons.emoji_emotions,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          onRefresh: controller.onRefreshLoadChildren,
          controller: controller.refreshController,
          child: Obx(
                () => !controller.isLoading.value
                ? controller.users.isNotEmpty
                    ?Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                  itemCount: controller.users.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String chatRoomId = controller.generateChatRoomId(UserStore.to.uid, controller.users[index].id.toString()?? '');

                                ChatRoomModel chatRoomModel = ChatRoomModel(
                                  users: [UserStore.to.uid, controller.users[index].id.toString()?? ''],
                                  usersProfile: [
                                    UserStore.to.profile.image?? '',
                                    controller.users[index].image?? ''
                                  ],
                                  usersName: [
                                    UserStore.to.profile.name?? '',
                                    controller.users[index].name?? ''
                                  ],
                                  lastMessage: "",
                                  lastMessageBy: "",
                                  lastMessageTm: DateTime.now(),
                                  chatRoomId: chatRoomId,
                                );
                                controller.createChatRoom(chatRoomModel, controller.users[index]);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 10,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(99, 136, 163, 181),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 26,
                                      backgroundImage: NetworkImage(
                                          'http://139.59.68.139:3000/uploads/${controller.users[index].image}' ?? ''),
                                    ),
                                    title: Text(
                                      controller.users[index].name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      controller.users[index].relation ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),
                        ),
                      ],
                    )
                    :const Center(
                  child: Text(
                    'No Child Found!',
                    style: TextStyle(color: Colors.black,fontSize: 18),
                  ),
                )
                : const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyChatList extends StatelessWidget {
  final List<Map<String, String>> dataList;

  MyChatList({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final item = dataList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ChatPage(),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(99, 136, 163, 181),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(item['imageUrl'] ?? ''),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['subtitle'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChatPage extends GetView<ChatSpaceController> {

  static const routeName = '/chatSpace';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Obx(
            () => ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  'http://139.59.68.139:3000/uploads/${controller.state.toUserProfile.value}'
                ),
              ),
              title: Text(
                controller.state.toUserName.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'You',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10, top: 5),
              child: Icon(
                Icons.emoji_emotions,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
        body: Obx(
          () => Chat(
            messages: controller.state.chatData,
            onAttachmentPressed: controller.handleAttachmentPressed,
            onMessageTap: controller.handleMessageTap,
            onPreviewDataFetched: controller.handlePreviewDataFetched,
            onSendPressed: controller.handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: controller.user,
          ),
        ),
      );
}
