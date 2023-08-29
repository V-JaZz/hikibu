import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/Cuddle_Screen/course_video.dart';
import 'package:hukibu/model/course_data.dart';
import 'package:hukibu/model/get_courses.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:hukibu/Screen/Cuddle_Screen/cuddle_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CuddleScreen extends StatefulWidget {
  final int id;
  final dynamic youtubeUrl;

  const CuddleScreen({required this.id, super.key, required this.youtubeUrl});

  @override
  State<CuddleScreen> createState() => _CuddleScreenState();
}

class _CuddleScreenState extends State<CuddleScreen>
    with TickerProviderStateMixin {
  YoutubePlayerController? _controller;
  List<Map<String, String>> dataList = [
    {
      'imageUrl': 'https://i.postimg.cc/KcP19fg8/avatar.png',
      'title': 'Namrata Sharma',
      'subtitle': 'Certified Children Educator',
    },
    {
      'imageUrl': 'https://i.postimg.cc/KcP19fg8/avatar.png',
      'title': 'Bharti Goal',
      'subtitle': 'Certified Children Educator',
    },
    {
      'imageUrl': 'https://i.postimg.cc/KcP19fg8/avatar.png',
      'title': 'Dr Divya Jose',
      'subtitle': 'Certified Children Educator',
    },

    // Add more items as needed
  ];

  List<String> cuddleHeader = [
    "Overcome Screen Addiction",
    "Get expert assistance and personal care in the beginning of your journey as a parent. Because, smart parents raise smart kids, happy parent raise happy kids",
    "\₹500",
  ];

  // late Future<Course> courseFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   courseFuture = fetchCourseDetail(widget.id) as Future<Course>;
  // }

  //---------new--------//

  CourseModel? courseModel;

  @override
  void initState() {
    super.initState();
    fetchData();

       if(widget.youtubeUrl != null && widget.youtubeUrl != ''){
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeUrl!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  void fetchData() async {
    var url = Uri.parse('http://139.59.68.139:3000/courses/get/${widget.id}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        courseModel = CourseModel.fromJson(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: courseModel!=null
          ? SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              widget.youtubeUrl == null || widget.youtubeUrl == '' || _controller == null
                  ?Image.network(
                'http://139.59.68.139:3000/uploads/${courseModel!.course.images}',
                // 'https://i.postimg.cc/J08fT6L1/IMG-2743.jpg',
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  :YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
            ),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  courseModel!.course.courseName.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  addNewlineBeforePoints(courseModel!.course.courseDesc.toString()),
                ),
              ),
              const SizedBox(height: 10),
              //======examples=======
              // Center(
              //   child: courseModel == null
              //       ? CircularProgressIndicator()
              //       : Text(courseModel!.course.courseName),
              // ),
              // Center(
              //   child: courseModel == null
              //       ? CircularProgressIndicator()
              //       : Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: courseModel!.course.whatYouGet
              //               .asMap()
              //               .entries
              //               .map((entry) {
              //             final index = entry.key;
              //             final item = entry.value;
              //             IconData iconData;

              //             // Assign different icons based on index or item value
              //             if (index == 0) {
              //               iconData = Icons.timer_outlined;
              //             } else if (index == 1) {
              //               iconData = Icons.person_2_rounded;
              //             } else if (index == 2) {
              //               iconData = Icons.local_activity;
              //             } else if (index == 3) {
              //               iconData = Icons.add_box_outlined;
              //             } else {
              //               iconData = Icons.info;
              //             }

              //             return Padding(
              //               padding: const EdgeInsets.all(3.0),
              //               child: Container(
              //                 height: MediaQuery.of(context).size.height / 18,
              //                 width: MediaQuery.of(context).size.width / 4.5,
              //                 decoration: BoxDecoration(
              //                   border: Border.all(
              //                     color: const Color.fromARGB(255, 94, 92, 92),
              //                   ),
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //                     Icon(
              //                         iconData), // Use the dynamically assigned icon
              //                     Text(
              //                       item,
              //                       style: TextStyle(fontSize: 12),
              //                     ).tr(),
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }).toList(),
              //         ),
              // ),

              // Center(
              //   child: courseModel == null
              //       ? CircularProgressIndicator()
              //       : ListView.builder(
              //           shrinkWrap: true,
              //           itemCount: courseModel!.course.whatYouGet.length,
              //           itemBuilder: (context, index) {
              //             return Container(
              //               height: MediaQuery.of(context).size.height / 18,
              //               width: MediaQuery.of(context).size.width / 4.5,
              //               decoration: BoxDecoration(
              //                 border: Border.all(
              //                     color: const Color.fromARGB(255, 94, 92, 92)),
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                   const Icon(Icons.local_activity),
              //                   Text(
              //                     courseModel!.course.whatYouGet[index],
              //                     style: TextStyle(fontSize: 12),
              //                   ).tr(),
              //                 ],
              //               ),
              //             );
              //             // return ListTile(
              //             //   title: Text(courseModel!.course.whatYouGet[index]),
              //             // );
              //           },
              //         ),
              // ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: courseModel!.instructorData.length,
              //   itemBuilder: (context, index) {
              //     var instructorData = courseModel!.instructorData[index];
              //     return ListTile(
              //       title: Text(instructorData.name),
              //       subtitle: Text(instructorData.occupation),
              //       // Add more properties as needed
              //     );
              //   },
              // ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: courseModel!.courseVideo.length,
              //   itemBuilder: (context, index) {
              //     var videoData = courseModel!.courseVideo[index];
              //     return ListTile(
              //       title: Text(videoData.name),
              //       subtitle: Text(videoData.description),
              //       // Add more properties as needed
              //     );
              //   },
              // ),

              // Container(
              //     height: MediaQuery.of(context).size.height / 3.3,
              //     width: double.infinity,
              //     decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [
              //           Colors.purple,
              //           Colors.blue,
              //         ],
              //         begin: FractionalOffset(0.5, 0.0),
              //         end: FractionalOffset(0.99, 0.0),
              //       ),
              //     ),
              //     child: Stack(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Image.asset('assets/images/img1.png'),
              //             Text.rich(
              //               TextSpan(children: [
              //                 TextSpan(
              //                   text: "cuddle".tr(),
              //                   style: const TextStyle(
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.white),
              //                 ),
              //                 const TextSpan(
              //                   text: "postnatal",
              //                   style: TextStyle(
              //                       fontSize: 10,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.white),
              //                 )
              //               ]),
              //             ),
              //           ],
              //         ),
              //       ],
              //     )),
              Container(
                color: const Color.fromARGB(255, 242, 238, 238),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CuddleHeader(dynamicTextList: cuddleHeader),

                      // FutureBuilder<List<Course>>(
                      //   future: fetchCourseDetail(widget.id),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       return Center(
                      //         child: Text('Failed to fetch course detail'),
                      //       );
                      //     } else if (snapshot.hasData) {
                      //       final courses = snapshot.data!;
                      //       // final List<Course> courses = snapshot.data!;
                      //       return ListView.builder(
                      //         shrinkWrap: true,
                      //         itemCount: courses.length,
                      //         itemBuilder: (context, index) {
                      //           final course = courses[index];
                      //           // final Course course = courses[index];
                      //           return ListTile(
                      //             title: Text(course.courseName),
                      //             // title:
                      //             //     Text('Course Name: ${course.courseName}'),
                      //             subtitle: Text(course.price.toString()),
                      //           );
                      //         },
                      //       );
                      //     } else {
                      //       return Container(); // Empty state
                      //     }
                      //   },
                      // ),

                      // const Text(
                      //   "cuddle postnatal",
                      //   style:
                      //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      // ).tr(),
                      // 30.heightBox,
                      // const Text(
                      //         "Get expert assistance and personal care in the beginning of your journey as a parent .Because,smart parents raise smart kids, happy parent raise happy kids")
                      //     .tr(),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: 8.0, left: 20),
                      //   child: Text(
                      //     "\$100",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.bold, fontSize: 20),
                      //   ),
                      // ),
                      // FutureBuilder<Course>(
                      //   future: courseFuture,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       return Center(
                      //         child: Text('Failed to fetch course details'),
                      //       );
                      //     } else if (snapshot.hasData) {
                      //       final course = snapshot.data!;
                      //       // return  Column(
                      //       //     children: [
                      //       //       Text(
                      //       //           'Course Description: ${course.courseDesc}'),
                      //       //       Text('Instructor: ${course.instructorName}'),
                      //       //       // Show other course details as needed
                      //       //     ],
                      //       //   );
                      //       return Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             course.courseName,
                      //             style: TextStyle(
                      //                 fontSize: 20, fontWeight: FontWeight.bold),
                      //           ),
                      //           SizedBox(height: 30),
                      //           Text(
                      //             course.courseDesc,
                      //           ),
                      //           SizedBox(height: 40),
                      //           Padding(
                      //             padding: EdgeInsets.only(top: 8.0, left: 20),
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text(
                      //                   '₹${course.price.toString()}',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 20),
                      //                 ),
                      //                 Container(
                      //                   height:
                      //                       MediaQuery.of(context).size.height /
                      //                           18,
                      //                   width:
                      //                       MediaQuery.of(context).size.width / 3,
                      //                   decoration: BoxDecoration(
                      //                     color: const Color.fromARGB(
                      //                         255, 2, 215, 112),
                      //                     borderRadius: BorderRadius.circular(20),
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceAround,
                      //                     children: [
                      //                       Text(
                      //                         "Join Now",
                      //                         style: TextStyle(
                      //                             fontWeight: FontWeight.bold),
                      //                       ),
                      //                       Icon(Icons.arrow_forward),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     } else {
                      //       return Container(); // Empty state
                      //     }
                      //   },
                      // ),
                      // 20.heightBox,
                      20.heightBox,
                      const Text(
                        "WHAT YOU GET",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ).tr(),
                      20.heightBox,
                      Center(
                        child: courseModel == null
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: courseModel!.course.whatYouGet
                                    !.asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  IconData iconData;

                                  // Assign different icons based on index or item value
                                  if (index == 0) {
                                    iconData = Icons.timer_outlined;
                                  } else if (index == 1) {
                                    iconData = Icons.person_2_rounded;
                                  } else if (index == 2) {
                                    iconData = Icons.local_activity;
                                  } else if (index == 3) {
                                    iconData = Icons.add_box_outlined;
                                  } else {
                                    iconData = Icons.info;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height / 18,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 94, 92, 92),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const SizedBox(width: 3),
                                          Icon(
                                              iconData),
                                          const SizedBox(width: 2),
                                          Text(
                                            item,
                                            style: const TextStyle(fontSize: 12),
                                          ).tr(),
                                          const SizedBox(width: 4),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       Container(
                      //         height: MediaQuery.of(context).size.height / 18,
                      //         width: MediaQuery.of(context).size.width / 5,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: const Color.fromARGB(255, 94, 92, 92)),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //           children: [
                      //             const Icon(Icons.timer_outlined),
                      //             const Text(
                      //               "5 mins\ndaily",
                      //               style: TextStyle(fontSize: 12),
                      //             ).tr(),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Container(
                      //         height: MediaQuery.of(context).size.height / 18,
                      //         width: MediaQuery.of(context).size.width / 4.5,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: const Color.fromARGB(255, 94, 92, 92)),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //           children: [
                      //             const Icon(Icons.person_2_rounded),
                      //             const Text(
                      //               "One to One\nSession",
                      //               style: TextStyle(fontSize: 10),
                      //             ).tr(),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Container(
                      //         height: MediaQuery.of(context).size.height / 18,
                      //         width: MediaQuery.of(context).size.width / 4.5,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: const Color.fromARGB(255, 94, 92, 92)),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //           children: [
                      //             const Icon(Icons.local_activity),
                      //             const Text(
                      //               "Activities",
                      //               style: TextStyle(fontSize: 12),
                      //             ).tr(),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Container(
                      //         height: MediaQuery.of(context).size.height / 18,
                      //         width: MediaQuery.of(context).size.width / 5,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: const Color.fromARGB(255, 94, 92, 92),
                      //           ),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //           children: [
                      //             const Icon(Icons.add_box_outlined),
                      //             const Text(
                      //               "Bounes",
                      //               style: TextStyle(fontSize: 12),
                      //             ).tr(),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 40,
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      CuddleDetails(id: widget.id)));
                          //  Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (ctx) => CuddleScreen(
                          //             //  id: courseList[index].id,
                          //             id: course.id,
                          //           ),
                          //         ),
                          //       );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 24,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              'EXPERT SUPPLY'.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      20.heightBox,
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: courseModel!.courseVideo.length,
                        itemBuilder: (context, index) {
                          CourseVideo videoData = courseModel!.courseVideo[index];
                          return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (ctx) => CourseVideoPlay(
                              //       id: videoData,
                              //     ),
                              //   ),
                              // );
                              Get.snackbar(
                                'Paid Course',
                                'Buy now in just ₹${courseModel!.course.price.toString()}',
                                snackStyle: SnackStyle.FLOATING,
                                icon: const Icon(
                                  Icons.person,
                                  color: Color(0xff28282B),
                                ),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.grey[200],
                                borderRadius: 10,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(15),
                                colorText: const Color(0xff28282B),
                                duration: const Duration(seconds: 4),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(195, 16, 89, 192),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 58.0),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    10.heightBox,
                                    Text(
                                      videoData.name,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             // Navigator.push(
                      //             //   context,
                      //             //   MaterialPageRoute(
                      //             //     builder: (ctx) => CourseVideo(),
                      //             //   ),
                      //             // );
                      //           },
                      //           child: Container(
                      //             height: MediaQuery.of(context).size.height / 5,
                      //             width: MediaQuery.of(context).size.width / 2.5,
                      //             decoration: BoxDecoration(
                      //               color: const Color.fromARGB(195, 16, 89, 192),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(top: 58.0),
                      //               child: Column(
                      //                 children: [
                      //                   const Icon(
                      //                     Icons.calendar_today,
                      //                     color: Colors.white,
                      //                     size: 20,
                      //                   ),
                      //                   10.heightBox,
                      //                   const Text(
                      //                     'Change After\n   Delivery',
                      //                     style: TextStyle(
                      //                         color: Colors.white, fontSize: 15),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           width: MediaQuery.of(context).size.width / 2.5,
                      //           decoration: BoxDecoration(
                      //             color: const Color.fromARGB(195, 16, 89, 192),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 58.0),
                      //             child: Column(
                      //               children: [
                      //                 const Icon(
                      //                   Icons.calendar_today,
                      //                   color: Colors.white,
                      //                   size: 20,
                      //                 ),
                      //                 10.heightBox,
                      //                 const Text(
                      //                   'Recovery Timeline',
                      //                   style: TextStyle(
                      //                       color: Colors.white, fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     15.heightBox,
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           width: MediaQuery.of(context).size.width / 2.5,
                      //           decoration: BoxDecoration(
                      //             color: const Color.fromARGB(195, 16, 89, 192),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 58.0),
                      //             child: Column(
                      //               children: [
                      //                 const Icon(
                      //                   Icons.calendar_today,
                      //                   color: Colors.white,
                      //                   size: 20,
                      //                 ),
                      //                 10.heightBox,
                      //                 const Text(
                      //                   'C-Section\n Recovery',
                      //                   style: TextStyle(
                      //                       color: Colors.white, fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           width: MediaQuery.of(context).size.width / 2.5,
                      //           decoration: BoxDecoration(
                      //             color: const Color.fromARGB(195, 16, 89, 192),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 58.0),
                      //             child: Column(
                      //               children: [
                      //                 const Icon(
                      //                   Icons.calendar_today,
                      //                   color: Colors.white,
                      //                   size: 20,
                      //                 ),
                      //                 10.heightBox,
                      //                 const Text(
                      //                   'Medical Needs',
                      //                   style: TextStyle(
                      //                       color: Colors.white, fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     15.heightBox,
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           width: MediaQuery.of(context).size.width / 2.5,
                      //           decoration: BoxDecoration(
                      //             color: const Color.fromARGB(195, 16, 89, 192),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 58.0),
                      //             child: Column(
                      //               children: [
                      //                 const Icon(
                      //                   Icons.calendar_today,
                      //                   color: Colors.white,
                      //                   size: 20,
                      //                 ),
                      //                 10.heightBox,
                      //                 const Text(
                      //                   'Family Report',
                      //                   style: TextStyle(
                      //                       color: Colors.white, fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           width: MediaQuery.of(context).size.width / 2.5,
                      //           decoration: BoxDecoration(
                      //             color: const Color.fromARGB(195, 16, 89, 192),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 58.0),
                      //             child: Column(
                      //               children: [
                      //                 const Icon(
                      //                   Icons.calendar_today,
                      //                   color: Colors.white,
                      //                   size: 20,
                      //                 ),
                      //                 10.heightBox,
                      //                 const Text(
                      //                   'Store the Banner',
                      //                   style: TextStyle(
                      //                       color: Colors.white, fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),

                      20.heightBox,
                    ],
                  ),
                ),
              ),
        ],
      ),
            ),
          )
          : const Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
//

// navin 27th june

class MyListView extends StatelessWidget {
  final List<Map<String, String>> dataList;

  MyListView({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final item = dataList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 10, // 12,
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color.fromARGB(99, 136, 163, 181),
                borderRadius: BorderRadius.circular(15)),
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
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                ),
                // trailing: Container(
                //   height: MediaQuery.of(context).size.height / 18,
                //   width: MediaQuery.of(context).size.width / 4,
                //   decoration: BoxDecoration(
                //       color: const Color.fromARGB(255, 2, 215, 112),
                //       borderRadius: BorderRadius.circular(20)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       const Text(
                //         "consult",
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ).tr(),
                //       const Icon(Icons.arrow_forward)
                //     ],
                //   ),
                // ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CuddleHeader extends StatelessWidget {
  final List<String> dynamicTextList;

  const CuddleHeader({required this.dynamicTextList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dynamicTextList[0],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Text(
          dynamicTextList[1],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dynamicTextList[2],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 18,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 2, 215, 112),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Join Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ).tr(),
                    const Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CuddleData {
  final String imageUrl;
  final String title;
  final String subtitle;

  CuddleData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  factory CuddleData.fromJson(Map<String, dynamic> json) {
    return CuddleData(
      imageUrl: json['imageUrl'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}

Future<CuddleData> fetchCuddleData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return CuddleData.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch user data');
  }
}

class CuddleHeaderData {
  final String title;
  final String description;
  final String price;

  CuddleHeaderData({
    required this.title,
    required this.description,
    required this.price,
  });

  factory CuddleHeaderData.fromJson(Map<String, dynamic> json) {
    return CuddleHeaderData(
      title: json['title'],
      description: json['description'],
      price: json['price'],
    );
  }
}

Future<CuddleHeaderData> fetchCuddleHeaderData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return CuddleHeaderData.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch user data');
  }
}

String addNewlineBeforePoints(String input) {
  final regex = RegExp(r'(\d+\.)');
  return input.replaceAllMapped(regex, (match) => '\n${match.group(1)}');
}
