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
import '../../services/storage.dart';
import 'getx_helper/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    TextEditingController searchController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    List<Course> courseList = [];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                      title: 'Confirm Exit App?'.tr(),
                      cancel: OutlinedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(OvalBorder())
                        ),
                          onPressed: () => Get.back(), child: Text('Cancel'.tr())),
                      confirm: ElevatedButton(
                          style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(OvalBorder())
                          ),
                          onPressed: () => exit(0), child: Text('Ok'.tr())),
                      content: const SizedBox.shrink(),
                      titlePadding: const EdgeInsets.only(top: 8),
                      buttonColor: Colors.indigo,
                      confirmTextColor: Colors.white,
                    );
                  },
                      icon: const Icon(Icons.exit_to_app_rounded,color: Colors.black)),
                ),
              ),
              20.heightBox,
              ListTile(
                title: Text("settings".tr()),
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
          title: const Text(
            "Aybala",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Course>>(
                future: controller.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
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
                    return Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              focusNode: focusNode,
                              onChanged: (value) => controller.filterCourses(value),
                              decoration: InputDecoration(
                                  labelText: "search".tr(),
                                  prefixIcon: const Icon(Icons.search),
                                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  filled: true,
                                  fillColor: Colors.white,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              controller.coursesLog = StorageService.to.getList('COURSE_SEARCH_LOG');
                              return Obx(
                                    () => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Visibility(
                                      visible: controller.courseSearchValue.value != '' && controller.coursesLog != [],
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 6,
                                        children: List.generate(controller.coursesLog.length,
                                                (i) {
                                              int index = controller.coursesLog.length - i-1;
                                              return InkWell(
                                                onTap: (){
                                                  FocusScope.of(context).unfocus();
                                                  searchController.text = controller.coursesLog[index];
                                                  controller.filterCourses(controller.coursesLog[index]);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                                                  child: Text(controller.coursesLog[index],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                          Obx(
                            () => ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: _controller,
                              itemCount: controller.visibleCoursesCount.value < courses.length
                                  ? controller.visibleCoursesCount.value + 1
                                  : courses.length,
                              itemBuilder: (context, index) {
                                final activity = courses[index];
                                if (index == controller.visibleCoursesCount.value) {
                                  // Render the "Show More" button when applicable
                                  return ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.indigo)
                                    ),
                                    onPressed: () {
                                      controller.showMoreCourses();
                                    },
                                    child: Text('Show More'.tr()),
                                  );
                                }
                                final course = courses[index];
                                return GestureDetector(
                                  onTap: () {

                                    controller.coursesLog = StorageService.to.getList('COURSE_SEARCH_LOG');

                                    Get.to(()=>CuddleScreen(
                                      id: course.id!,
                                      youtubeUrl: course.youtubelink,
                                    ));

                                    if(controller.courseSearchValue.value != ''){
                                      if(!controller.coursesLog.contains(course.courseName!.toLowerCase())) {
                                        if(controller.coursesLog.length == 5) controller.coursesLog.removeAt(0);
                                        controller.coursesLog.add(course.courseName!.toLowerCase());
                                        StorageService.to.setList('COURSE_SEARCH_LOG', controller.coursesLog);
                                      }
                                    }
                                    controller.courseSearchValue.value = '';
                                    searchController.text = '';
                                    controller.filterCourses('');
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
                      ),
                    );
                  } else {
                    return Container(); // Empty state
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
