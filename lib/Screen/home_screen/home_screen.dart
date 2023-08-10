import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hukibu/Screen/add_new_child.dart';
import 'package:hukibu/Screen/Cuddle_Screen/cuddle.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/model/get_courses.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import 'getx_helper/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    List<String> imageUrls = [
      'https://i.postimg.cc/J08fT6L1/IMG-2743.jpg',
      'https://i.postimg.cc/Pf8bKX3r/IMG-2744.jpg',
      'https://i.postimg.cc/fbLmdDSs/IMG-2745.jpg',
      'https://i.postimg.cc/L6m0YgDZ/kid3.jpg',
      'https://i.postimg.cc/nrBTjpj2/kelli-mcclintock-w-Bg-AVAGjz-Fg-unsplash.jpg',
      'https://i.postimg.cc/J4wM9x1C/kid1.jpg',
      'https://i.postimg.cc/QMzRcNCZ/kid2.jpg',
    ];

    List<Course> courseList = [];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 20, top: 80),
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
                Navigator.of(context).pop();
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
        // actions: [
        //   const Center(
        //     child: Text('English'),
        //   ),
        //   Switch(
        //     onChanged: (val) async {
        //       controller.toggleSwitch(val);
        //     },
        //     value: context.locale.toString() == 'en_US' ? false : true,
        //     activeColor: Colors.purpleAccent,
        //     activeTrackColor: Colors.purple,
        //     inactiveThumbColor: Colors.deepPurple,
        //     inactiveTrackColor: Colors.deepPurpleAccent,
        //   ),
        //   const Center(
        //     child: Text('Turkish'),
        //   ),
        // ],
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: const Text(
                "Recommended Courses",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ).tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Course>>(
              future: fetchCourses(),
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
                  final courses = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: courses.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(()=>CuddleScreen(
                            id: course.id,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.network(
                                  'http://13.127.11.171:3000/uploads/${course.images}',
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
                                        course.courseName,
                                        style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white),
                                      ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
