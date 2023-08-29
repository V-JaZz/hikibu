import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hukibu/model/course_data.dart';
import 'package:hukibu/model/get_activities.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

import '../child_screen/sensorry_bottle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseVideoPlay extends StatelessWidget {
  final CourseVideo id;
  const CourseVideoPlay({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      key: const ValueKey<String>('home_page'),
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            "Hukibu",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _BumbleBeeRemoteVideo(
        videoData: id,
      ),
    );
  }
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  final CourseVideo videoData;
  const _BumbleBeeRemoteVideo({required this.videoData, super.key});
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final String fileContents = await DefaultAssetBundle.of(context)
  //       .loadString('assets/bumble_bee_captions.vtt');
  //   return WebVTTCaptionFile(
  //       fileContents); // For vtt files, use WebVTTCaptionFile
  // }

  CourseModel? courseModel;

  // void fetchData() async {
  //   var url = Uri.parse('http://13.126.205.178:3000/courses/get/${widget.id}');

  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     print(response.body.toString());
  //     setState(() {
  //       courseModel = CourseModel.fromJson(jsonResponse);
  //     });
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print('http://139.59.68.139:3000/uploads/${widget.videoData.videoUrl}');
    // fetchData();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
        'http://139.59.68.139:3000/uploads/${widget.videoData.videoUrl}'));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: true,
      // Other Chewie options...
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/bg.jpg"),
        fit: BoxFit.cover,
      )),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              // aspectRatio: _videoPlayerController.value.aspectRatio,
              aspectRatio: 2 / 1,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
            // Container(padding: const EdgeInsets.only(top: 20.0)),
            // const Text('EP : 01'),
            ListTile(
              title: Text(
                widget.videoData.name,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              subtitle: Text(
                widget.videoData.description,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),

            SizedBox(
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share),
                      Text('Share with friends'),
                    ],
                  )),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recommended Activities',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            15.heightBox,

            FutureBuilder<List<Activity>>(
              future: fetchActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Failed to fetch courses'),
                  );
                } else if (snapshot.hasData) {
                  final activities = snapshot.data!;
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
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
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'http://139.59.68.139:3000/uploads/${activity.image}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  color: const Color.fromARGB(85, 0, 0, 0),
                                  filterQuality: FilterQuality.high,
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  20.heightBox,
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.amber,
                                    child: const Center(
                                      child: Text(
                                        'Handpicked for hqider',
                                        style: TextStyle(
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      // 'Sensory Bottles',
                                      '${activity.name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  )
                                ],
                              )
                            ],
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
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (ctx) =>  SensorryBottle(),
            //     //   ),
            //     // );
            //   },
            //   child: Container(
            //     height: MediaQuery.of(context).size.height / 2.8,
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
            //               padding: const EdgeInsets.only(top: 80.0, left: 10),
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
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}

// class _ControlsOverlay extends StatelessWidget {
//   const _ControlsOverlay({required this.controller});
//
//   static const List<Duration> _exampleCaptionOffsets = <Duration>[
//     Duration(seconds: -10),
//     Duration(seconds: -3),
//     Duration(seconds: -1, milliseconds: -500),
//     Duration(milliseconds: -250),
//     Duration.zero,
//     Duration(milliseconds: 250),
//     Duration(seconds: 1, milliseconds: 500),
//     Duration(seconds: 3),
//     Duration(seconds: 10),
//   ];
//   static const List<double> _examplePlaybackRates = <double>[
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];
//
//   final VideoPlayerController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? const SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 100.0,
//                       semanticLabel: 'Play',
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: PopupMenuButton<Duration>(
//             initialValue: controller.value.captionOffset,
//             tooltip: 'Caption Offset',
//             onSelected: (Duration delay) {
//               controller.setCaptionOffset(delay);
//             },
//             itemBuilder: (BuildContext context) {
//               return <PopupMenuItem<Duration>>[
//                 for (final Duration offsetDuration in _exampleCaptionOffsets)
//                   PopupMenuItem<Duration>(
//                     value: offsetDuration,
//                     child: Text('${offsetDuration.inMilliseconds}ms'),
//                   )
//               ];
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 // Using less vertical padding as the text is also longer
//                 // horizontally, so it feels like it would need more spacing
//                 // horizontally (matching the aspect ratio of the video).
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: PopupMenuButton<double>(
//             initialValue: controller.value.playbackSpeed,
//             tooltip: 'Playback speed',
//             onSelected: (double speed) {
//               controller.setPlaybackSpeed(speed);
//             },
//             itemBuilder: (BuildContext context) {
//               return <PopupMenuItem<double>>[
//                 for (final double speed in _examplePlaybackRates)
//                   PopupMenuItem<double>(
//                     value: speed,
//                     child: Text('${speed}x'),
//                   )
//               ];
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 // Using less vertical padding as the text is also longer
//                 // horizontally, so it feels like it would need more spacing
//                 // horizontally (matching the aspect ratio of the video).
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               child: Text('${controller.value.playbackSpeed}x'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PlayerVideoAndPopPage extends StatefulWidget {
//   @override
//   _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
// }

// class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
//   late VideoPlayerController _videoPlayerController;
//   bool startedPlaying = false;

//   @override
//   void initState() {
//     super.initState();

//     _videoPlayerController =
//         VideoPlayerController.asset('assets/Butterfly-209.mp4');
//     _videoPlayerController.addListener(() {
//       if (startedPlaying && !_videoPlayerController.value.isPlaying) {
//         Navigator.pop(context);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   Future<bool> started() async {
//     await _videoPlayerController.initialize();
//     await _videoPlayerController.play();
//     startedPlaying = true;
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: FutureBuilder<bool>(
//           future: started(),
//           builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//             if (snapshot.data ?? false) {
//               return AspectRatio(
//                 aspectRatio: _videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(_videoPlayerController),
//               );
//             } else {
//               return const Text('waiting for video to load');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class CourseVideo extends StatefulWidget {
//   @override
//   _VideoPlayerPageState createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<CourseVideo> {
//   late VideoPlayerController _controller;
//   List<String> videoUrls = [
//     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
//     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
//   ];
//   int currentVideoIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(videoUrls[currentVideoIndex])
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void playNextVideo() {
//     if (currentVideoIndex < videoUrls.length - 1) {
//       currentVideoIndex++;
//       _controller = VideoPlayerController.network(videoUrls[currentVideoIndex])
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: playNextVideo,
//         child: Icon(Icons.skip_next),
//       ),
//     );
//   }
// }

// class CourseVideo extends StatefulWidget {
//   const CourseVideo({Key? key}) : super(key: key);

//   @override
//   State<CourseVideo> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<CourseVideo> {
//   late VideoPlayerController videoPlayerController;
//   late CustomVideoPlayerController _customVideoPlayerController;

//   String videoUrl =
//       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

//   @override
//   void initState() {
//     super.initState();
//     // ignore: deprecated_member_use
//     videoPlayerController = VideoPlayerController.network(videoUrl)
//       ..initialize().then((value) => setState(() {}));
//     _customVideoPlayerController = CustomVideoPlayerController(
//       context: context,
//       videoPlayerController: videoPlayerController,
//     );
//   }

//   @override
//   void dispose() {
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text('test'),
//       ),
//       child: SafeArea(
//         child: CustomVideoPlayer(
//             customVideoPlayerController: _customVideoPlayerController),
//       ),
//     );
//   }
// }
