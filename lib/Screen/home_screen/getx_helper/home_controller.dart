import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hukibu/Screen/home_screen/bottomnavigate.dart';
import 'package:hukibu/Screen/home_screen/getx_helper/home_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../../API/api_client.dart';
import '../../../main.dart';
import '../../../model/app_data/child_model.dart';
import '../../../model/get_activities.dart';
import '../../../model/get_courses.dart';
import '../../../services/user.dart';

class HomeController extends GetxController {

  HomeState state = HomeState();
  Rx<String> image = ''.obs;
  Rx<String> imageURL = ''.obs;
  Rx<bool> isSwitched = false.obs;
  final searchController = TextEditingController();
  Rx<bool> viewAll = false.obs;
  Rx<bool> test = false.obs;

  RxList<Course> courses = <Course>[].obs;
  RxList<Course> filteredCourseList = <Course>[].obs;

  RxList<Activity> activities = <Activity>[].obs;
  RxList<Activity> filteredActivitiesList = <Activity>[].obs;

  @override
  Future<void> onInit() async {
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    Response res = await ApiClient.to.getData(
      'http://139.59.68.139:3000/getChildById/${UserStore.to.uid}'
    );
    print(res.body);
    if ((res.body??[]) != []){
      for(var child in res.body){
        state.childList.add(ChildModel.fromJson(res.body));
      }
    }
  }

  void toggleSwitch(bool value) {
    if (isSwitched.value == false) {
      isSwitched.value = true;
      changeLocale(Get.context!);

    } else {
      isSwitched.value = false;
      changeLocale(Get.context!);
    }
    Get.defaultDialog(
      title: 'Restart?',
      content: const Text('Restart app now to apply changes!'),
      confirm: TextButton(onPressed: (){Restart.restartApp();}, child: const Text('Ok')) ,
      cancel: TextButton(onPressed: (){Get.back();}, child: const Text('Cancel'))
    );
  }

  Future<void> changeLocale(BuildContext context) async {
    if (isSwitched.value) {
      context.setLocale(const Locale('en', 'US'));
    } else {
      context.setLocale(const Locale('tr', 'TR'));
    }
    update();
  }


    getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image.value = pickedFile.path;
      Response res = await ApiClient.to.postData(
        'http://139.59.68.139:3000/user/upload-profile/${UserStore.to.uid}',
        {},
      );
    }
  }

  bottomSheet() {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getImageFromGallery();
              Get.back();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Course>> getCourses() async {
    courses.value = await fetchCourses();
    filteredCourseList.assignAll(courses);
    return courses;
  }

  void filterCourses(String query) {
    filteredCourseList.assignAll(
      courses.where(
            (course) => course.courseName!.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  Future<List<Activity>> getActivities() async {
    activities.value = await fetchActivities();
    filteredActivitiesList.assignAll(activities);
    return activities;
  }

  void filterActivities(String query) {
    filteredActivitiesList.assignAll(
      activities.where(
            (activity) => activity.name!.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

}