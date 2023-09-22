import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/BottomSheet/cognitive_bottom.dart';
import 'package:hukibu/Screen/BottomSheet/language_bottom.dart';
import 'package:hukibu/Screen/BottomSheet/physical_bottom.dart';
import 'package:hukibu/Screen/BottomSheet/socail_bottom.dart';
import 'package:hukibu/Screen/child_screen/sensorry_bottle.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/model/get_activities.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../services/storage.dart';
import 'add_new_child.dart';
import 'child_screen/survey.dart';
import 'home_screen/getx_helper/home_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MyChild extends GetView<HomeController> {
  const MyChild({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    TextEditingController searchController = TextEditingController();
    final FocusNode focusNode = FocusNode();

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
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Obx(
              () => !controller.test.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 15,
                  //   width: MediaQuery.of(context).size.width / 1.05,
                  //   decoration: BoxDecoration(
                  //     color: const Color.fromARGB(209, 227, 27, 5),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: const Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Icon(
                  //         Icons.error_sharp,
                  //         color: Colors.white,
                  //       ),
                  //       Text.rich(
                  //         TextSpan(
                  //           children: [
                  //             TextSpan(
                  //               text: 'Important! Evaluation Pending!\n',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.white,
                  //                 fontSize: 15,
                  //               ),
                  //             ),
                  //             TextSpan(
                  //               text: 'Answer the question about Alis',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       Icon(
                  //         Icons.arrow_forward,
                  //         color: Colors.white,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  15.heightBox,
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 2.4,
                  //   width: MediaQuery.of(context).size.width / 1.05,
                  //   decoration: BoxDecoration(
                  //     color: const Color.fromARGB(255, 219, 217, 215),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: const Column(
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.all(10.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               "Alis's Evaluation Report",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 17,
                  //               ),
                  //             ),
                  //             Text(
                  //               'Help',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 17,
                  //                 color: Color.fromARGB(255, 33, 61, 243),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.only(top: 100.0),
                  //         child: CircleAvatar(
                  //           radius: 50,
                  //           backgroundColor: Colors.amber,
                  //           backgroundImage: AssetImage('assets/images/empty.webp'),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  StorageService.to.getString('selectedChildName') != '' && !controller.viewAll.value
                      ? Container(
                    width: MediaQuery.of(context).size.width / 1.05,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 219, 217, 215),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${StorageService.to.getString('selectedChildName')},s ${'evaluation report'.tr()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Get.to(()=>ReSurvey(childId: StorageService.to.getString('selectedChild')));
                                  },
                                  child: Text(
                                    'survey'.tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 33, 61, 243)),
                                  )
                              )
                            ],
                          ),
                        ),
                        18.heightBox,
                        // Column(
                        //   children: [
                        //     InkWell(
                        //       onTap: () async {
                        //         showModalBottomSheet(
                        //             context: context,
                        //             builder: (builder) => physicalBottom());
                        //       },
                        //       child: Container(
                        //         // height: MediaQuery.of(context).size.height / 7,
                        //         // width: MediaQuery.of(context).size.width / 4.8,
                        //         height: 80,
                        //         width: 80,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(color: Colors.black),
                        //             color: Colors.white,
                        //             shape: BoxShape.circle),
                        //         child: Column(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           children: const [
                        //             Icon(Icons.person),
                        //             Text(
                        //               'Physical',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             Divider(
                        //               endIndent: 20,
                        //               indent: 20,
                        //               thickness: 8,
                        //               color: Colors.green,
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     5.heightBox,
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 40.0),
                        //       child: Row(
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               showModalBottomSheet(
                        //                   context: context,
                        //                   builder: (builder) => SocialBottom());
                        //             },
                        //             child: Container(
                        //               // height: MediaQuery.of(context).size.height / 7,
                        //               // width: MediaQuery.of(context).size.width / 4.8,
                        //               height: 80,
                        //               width: 80,
                        //               decoration: BoxDecoration(
                        //                   border:
                        //                       Border.all(color: Colors.black),
                        //                   color: Colors.white,
                        //                   shape: BoxShape.circle),
                        //               child: Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceAround,
                        //                 children: const [
                        //                   Icon(Icons.face_retouching_natural),
                        //                   Text(
                        //                     'Social and\nEmotional',
                        //                     style: TextStyle(
                        //                         fontSize: 12,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                   Divider(
                        //                     endIndent: 20,
                        //                     indent: 20,
                        //                     thickness: 8,
                        //                     color: Colors.green,
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           5.widthBox,
                        //           const CircleAvatar(
                        //             radius: 45,
                        //             backgroundColor: Colors.amberAccent,
                        //           ),
                        //           5.widthBox,
                        //           InkWell(
                        //             onTap: () {
                        //               showModalBottomSheet(
                        //                   context: context,
                        //                   builder: (builder) =>
                        //                       CognitiveBottom());
                        //             },
                        //             child: Container(
                        //               // height: MediaQuery.of(context).size.height / 7,
                        //               // width: MediaQuery.of(context).size.width / 4.8,
                        //               height: 80,
                        //               width: 80,
                        //               decoration: BoxDecoration(
                        //                   border:
                        //                       Border.all(color: Colors.black),
                        //                   color: Colors.white,
                        //                   shape: BoxShape.circle),
                        //               child: Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceAround,
                        //                 children: const [
                        //                   Icon(Icons.heart_broken_outlined),
                        //                   Text(
                        //                     'Cognitive',
                        //                     style: TextStyle(
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                   Divider(
                        //                     endIndent: 20,
                        //                     indent: 20,
                        //                     thickness: 8,
                        //                     color: Colors.green,
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     5.heightBox,
                        //     InkWell(
                        //       onTap: () {
                        //         showModalBottomSheet(
                        //             context: context,
                        //             builder: (builder) => LanguageBottom());
                        //       },
                        //       child: Container(
                        //         // height: MediaQuery.of(context).size.height / 7,
                        //         // width: MediaQuery.of(context).size.width / 4.8,
                        //         height: 80,
                        //         width: 80,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(color: Colors.black),
                        //             color: Colors.white,
                        //             shape: BoxShape.circle),
                        //         child: const Column(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           children: [
                        //             Icon(Icons.message),
                        //             Text(
                        //               'Language',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             Divider(
                        //               endIndent: 20,
                        //               indent: 20,
                        //               thickness: 8,
                        //               color: Colors.green,
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => CognitiveBottom());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomStepIndicator(
                                currentStep:
                                Random().nextInt(7)+3, // Replace with the current step value
                                totalSteps:
                                    10, // Replace with the total number of steps
                                icon: Icons
                                    .heart_broken_outlined, // Replace with the desired icon
                                labelText:
                                    'Cognitive'.tr(), // Replace with the desired label text
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => SocialBottom());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomStepIndicator(
                                currentStep:
                                Random().nextInt(7)+3, // Replace with the current step value
                                totalSteps:
                                    10, // Replace with the total number of steps
                                icon: Icons
                                    .child_care, // Replace with the desired icon
                                labelText:
                                    'Socil-Emo'.tr(), // Replace with the desired label text
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => physicalBottom());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomStepIndicator(
                                currentStep:
                                Random().nextInt(7)+3, // Replace with the current step value
                                totalSteps:
                                    10, // Replace with the total number of steps
                                icon:
                                    Icons.person, // Replace with the desired icon
                                labelText:
                                    'Physical'.tr(), // Replace with the desired label text
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => LanguageBottom());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomStepIndicator(
                                currentStep:
                                Random().nextInt(7)+3, // Replace with the current step value
                                totalSteps:
                                    10, // Replace with the total number of steps
                                icon: Icons.chat, // Replace with the desired icon
                                labelText:
                                    'Language'.tr(), // Replace with the desired label text
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  :const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${StorageService.to.getString('selectedChildName') != '' && !controller.viewAll.value? '':'all'.tr()} ${'activities'.tr()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if(StorageService.to.getString('selectedChildName') != '')
                          TextButton(
                            onPressed: () {
                              controller.viewAll.value = !controller.viewAll.value;
                            },
                            child: Text(
                              !controller.viewAll.value?'view all'.tr():'go back'.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 33, 61, 243)),
                            )
                        )
                      ],
                    ),
                  ),
                  StorageService.to.getString('selectedChildName') == '' || controller.viewAll.value
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            focusNode: focusNode,
                            controller: searchController,
                            onChanged: (value) => controller.filterActivities(value),
                            decoration: InputDecoration(
                                labelText: "search".tr(),
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                filled: true,
                                fillColor: Colors.white
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            controller.activityLog = StorageService.to.getList('ACTIVITY_SEARCH_LOG');
                            return Obx(
                              () => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Visibility(
                                  visible: controller.activitySearchValue.value != '' && controller.activityLog != [],
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 6,
                                    children: List.generate(controller.activityLog.length,
                                            (i) {
                                              int index = controller.activityLog.length - i-1;
                                              return InkWell(
                                          onTap: (){
                                            FocusScope.of(context).unfocus();
                                            searchController.text = controller.activityLog[index];
                                            controller.filterActivities(controller.activityLog[index]);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                                            child: Text(controller.activityLog[index],
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
                    ],
                  )
                      :const SizedBox.shrink(),

                  FutureBuilder<List<Activity>>(
                    future: controller.getActivities(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _controller,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
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
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Failed to fetch activities'),
                        );
                      } else if (snapshot.hasData) {
                        final activities = controller.filteredActivitiesList;
                        return Obx(
                          () => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: controller.visibleActivitiesCount.value < activities.length
                                ? controller.visibleActivitiesCount.value + 1
                                : activities.length,
                            itemBuilder: (context, index) {
                              final activity = activities[index];
                              if (index == controller.visibleActivitiesCount.value) {
                                // Render the "Show More" button when applicable
                                return ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.indigo)
                                  ),
                                  onPressed: () {
                                    controller.showMoreActivities();
                                  },
                                  child: Text('Show More'.tr()),
                                );
                              }
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (ctx) => CuddleScreen(
                                  //       id: course.id,
                                  //     ),
                                  //   ),
                                  // );

                                  Get.to(() => SensorryBottle(
                                      id: activity.id!,
                                      favorite: null,
                                      completed: null
                                  ));

                                  controller.activityLog = StorageService.to.getList('ACTIVITY_SEARCH_LOG');
                                  if(controller.activitySearchValue.value != ''){
                                    if(!controller.activityLog.contains(activity.name!.toLowerCase())) {
                                      if(controller.activityLog.length == 5) controller.activityLog.removeAt(0);
                                      controller.activityLog.add(activity.name!.toLowerCase());
                                      StorageService.to.setList('ACTIVITY_SEARCH_LOG', controller.activityLog);
                                    }
                                  }
                                  controller.activitySearchValue.value = '';
                                  searchController.text = '';
                                  controller.filterActivities('');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          'http://139.59.68.139:3000/uploads/${activity.image}',
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: double.infinity,
                                            height: Get.width/2,
                                            color: const Color.fromARGB(85, 0, 0, 0),
                                            child: Center(
                                              child: Text(
                                                'NULL IMAGE \n($error)',
                                                style: const TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: Get.width/2,
                                          color: const Color.fromARGB(85, 0, 0, 0),
                                          filterQuality: FilterQuality.high,
                                          colorBlendMode: BlendMode.darken,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          20.heightBox,
                                          Container(
                                            height:
                                                MediaQuery.of(context).size.height /
                                                    25,
                                            width:
                                                MediaQuery.of(context).size.width /
                                                    2,
                                            color: Colors.amber,
                                            child: Center(
                                              child: Text(
                                                  '${activity.name}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 80.0, left: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.light_mode,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                10.widthBox,
                                                Text(
                                                  // '20 min',
                                                  '${activity.timeDuration} min',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.heightBox,
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
                                            margin: const EdgeInsets.only(left: 9.0),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(
                                              // 'Sensory Bottles',
                                              '${activity.labels}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(); // Empty state
                      }
                    },
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (ctx) => const SensorryBottle(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 2.4,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //       color: Colors.amber,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/3.webp',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Sensory Bottles',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const MakeSomeMusic()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 2.4,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/4.webp',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '25 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Make Some Music',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const WaterPainting()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 2.4,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/7.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Water Painting',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const FrozenBalloons()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 2.4,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/8.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '30 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Frozen Balloons',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (ctx) => const JellyDig()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 2.4,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/6.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '30 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Jelly Dig',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const WindoeArts()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 3.8,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/9.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Window Arts',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const MirrorTime()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 3.8,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/10.jpg',
                  //             fit: BoxFit.cover,
                  //             height: double.infinity,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Mirror Time',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (ctx) => const MashWash()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 3.8,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/5.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Mash Wash',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const GiveMeTime()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 3.8,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/2.2.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Give me some Bubbles',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // 15.heightBox,
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (ctx) => const Squchy()));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 3.8,
                  //     width: MediaQuery.of(context).size.width / 1.05,
                  //     decoration: BoxDecoration(
                  //         color: Colors.amber,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Image.asset(
                  //             'assets/images/1.1.jpg',
                  //             fit: BoxFit.cover,
                  //             width: double.infinity,
                  //             color: const Color.fromARGB(85, 0, 0, 0),
                  //             filterQuality: FilterQuality.high,
                  //             colorBlendMode: BlendMode.darken,
                  //           ),
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             20.heightBox,
                  //             Container(
                  //               height: MediaQuery.of(context).size.height / 25,
                  //               width: MediaQuery.of(context).size.width / 2,
                  //               color: Colors.amber,
                  //               child: const Center(
                  //                 child: Text(
                  //                   'Handpicked for hqider',
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontStyle: FontStyle.italic,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 80.0, left: 10),
                  //               child: Row(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.light_mode,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   ),
                  //                   10.widthBox,
                  //                   const Text(
                  //                     '20 min',
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             10.heightBox,
                  //             const Padding(
                  //               padding: EdgeInsets.only(left: 8.0),
                  //               child: Text(
                  //                 'Squchy Squchy',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                     fontSize: 20),
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              )
                  :const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final IconData icon;
  final String labelText;

  CustomStepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.icon,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIconAndText(),
        const SizedBox(width: 10),
        Expanded(
          child: StepProgressIndicator(
            totalSteps: totalSteps,
            currentStep: currentStep,
            size: 12,
            padding: 0,
            selectedColor: Colors.green,
            unselectedColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildIconAndText() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pinkAccent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          Text(
            labelText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
