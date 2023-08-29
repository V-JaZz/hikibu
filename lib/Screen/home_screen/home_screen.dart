import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/add_new_child.dart';
import 'package:hukibu/Screen/Cuddle_Screen/cuddle.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/model/get_courses.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share/share.dart';
import '../../main.dart';
import 'getx_helper/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();

    List<Course> courseList = [];

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
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (builder) => controller.bottomSheet(),
                      // );
                    },
                    child: Obx(
                          () => CircleAvatar(
                        radius: 30,
                        backgroundColor:
                        const Color.fromARGB(255, 239, 238, 235),
                        child: controller.imageURL.value != ''
                            ? ClipOval(
                          child: Image.network(
                            controller.imageURL.value,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                            : controller.image.value != ''
                            ? ClipOval(
                          child: Image.file(
                            File(controller.image.value),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                            : ClipOval(
                          child:
                          Image.asset('assets/images/empty.webp'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
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
            50.heightBox,
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
            ListTile(
              title: const Text("settings").tr(),
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SettingScreen()));
              },
            ),
            20.heightBox,
          ],
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Hukibu",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Center(
            child: Text('English'),
          ),
          Switch(
            onChanged: (val) {
              controller.toggleSwitch(val);
            },
            value: context.locale.toString() == 'en_US' ? false : true,
            activeColor: Colors.purpleAccent,
            activeTrackColor: Colors.purple,
            inactiveThumbColor: Colors.deepPurple,
            inactiveTrackColor: Colors.deepPurpleAccent,
          ),
          const Center(
            child: Text('Turkish'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        )),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Course>>(
              future: controller.getCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromARGB(248, 188, 187, 187),
                              highlightColor: Colors.white,
                              period: const Duration(seconds: 1),
                              child: Container(
                                color: Colors.white,
                                height:
                                MediaQuery.of(context).size.height /
                                    3.8,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Failed to fetch courses'),
                  );
                } else if (snapshot.hasData) {
                  final courses = controller.filteredCourseList;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) => controller.filterCourses(value),
                          decoration: InputDecoration(
                              labelText: "search".tr(),
                              prefixIcon: const Icon(Icons.search),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),
                      ),
                      Obx(
                        () => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _controller,
                          itemCount: courses.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(()=>CuddleScreen(
                                  id: course.id!,
                                  youtubeUrl: course.youtubelink,
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        'http://139.59.68.139:3000/uploads/${course.images}',
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey,
                                          height:
                                          MediaQuery.of(context).size.height /
                                              3.8,
                                          width: double.infinity,
                                          child: Center(
                                            child: Text(
                                              'NULL IMAGE \n($error)',
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3.8,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            color: Colors.indigo,
                                            child: Text(
                                              course.courseName.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white),
                                            ),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(); // Empty state
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
