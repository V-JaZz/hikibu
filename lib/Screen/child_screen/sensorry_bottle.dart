import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hukibu/Screen/home_screen/bottomnavigate.dart';
import 'package:hukibu/model/activities_data.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../routes/route_paths.dart';
import '../../services/storage.dart';
import '../home_screen/home_screen.dart';

class SensorryBottle extends StatefulWidget {
  final int id;
  final int? favorite;
  final int? completed;
  const SensorryBottle({required this.id, super.key, required this.favorite, required this.completed});

  @override
  State<SensorryBottle> createState() => _SensorryBottleState();
}

class _SensorryBottleState extends State<SensorryBottle> {
  int currentStep = 0;

  ActivityModel? activityModel;
  int? f;
  int? c;
  @override
  void initState() {
    super.initState();
    fetchData();
    f = widget.favorite;
    c = widget.completed;
  }

  void fetchData() async {
    var url = Uri.parse('http://13.127.11.171:3000/getActivity/${widget.id}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        activityModel = ActivityModel.fromJson(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(RoutePaths.homeScreen);
          return false;
        },
        child: SingleChildScrollView(
          child:activityModel!=null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.8,
                    width: MediaQuery.of(context).size.width / 1,
                    child: Stack(
                      children: [
                        Image.network(
                          'http://13.127.11.171:3000/uploads/${activityModel!.activity.image}',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          color: const Color.fromARGB(85, 0, 0, 0),
                          filterQuality: FilterQuality.high,
                          colorBlendMode: BlendMode.darken,
                        ),
                        // Image.asset(
                        //   'assets/images/3.webp',
                        //   fit: BoxFit.cover,
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   color: const Color.fromARGB(85, 0, 0, 0),
                        //   filterQuality: FilterQuality.high,
                        //   colorBlendMode: BlendMode.darken,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 108.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 25,
                            width: MediaQuery.of(context).size.width / 2,
                            color: Colors.amber,
                            child: Center(
                              child: Text(
                                'Handpicked ${StorageService.to.getString('selectedChildName')!=''?'for ${StorageService.to.getString('selectedChildName')}' :''}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      // 'Sensory Bottles',
                      activityModel!.activity.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  20.heightBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.light_mode,
                          // color: Colors.black,
                          size: 20,
                        ),
                        10.widthBox,
                        Text(
                          '${activityModel!.activity.timeDuration} min',
                          // '20 min',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              //color: Colors.black,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  Container(
                    height: MediaQuery.of(context).size.height / 7,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 217, 216, 216),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text.rich(TextSpan(children: [
                            TextSpan(
                                text: '   Materials needed\n',
                                style: TextStyle(fontSize: 18)),
                            // TextSpan(
                            //     text: 'Bottle,Gliter,Color,Torch',
                            //     style: TextStyle(fontSize: 18)),
                          ])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int index = 0;
                                  index <
                                      (activityModel?.materialData.length ?? 0);
                                  index++)
                                Row(
                                  children: [
                                    Text(
                                      activityModel?.materialData[index]
                                              .materialName ??
                                          '',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    if (index <
                                        (activityModel?.materialData.length ??
                                                0) -
                                            1)
                                      const Text(','),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activityModel?.stepData.length ?? 0,
                    itemBuilder: (context, index) {
                      final stepData = activityModel?.stepData[index];
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: true,
                        indicatorStyle: const IndicatorStyle(
                          width: 20,
                          color: Color.fromARGB(255, 145, 150, 147),
                          padding: EdgeInsets.all(6),
                        ),
                        endChild: Text(stepData?.stepDescription ?? '',
                            style: const TextStyle(fontSize: 16)),
                        beforeLineStyle: const LineStyle(
                          color: Color.fromARGB(255, 145, 150, 147),
                        ),
                      );
                    },
                  ),
                  // TimelineTile(
                  //   alignment: TimelineAlign.manual,
                  //   lineXY: 0.1,
                  //   isFirst: true,
                  //   indicatorStyle: const IndicatorStyle(
                  //     width: 20,
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //     padding: EdgeInsets.all(6),
                  //   ),
                  //   endChild: const Text(
                  //       'Make 3-4 bottles and each fill with differrent colored paints and glitters ',
                  //       style: TextStyle(fontSize: 16)),
                  //   beforeLineStyle: const LineStyle(
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //   ),
                  // ),
                  // TimelineTile(
                  //   alignment: TimelineAlign.manual,
                  //   axis: TimelineAxis.vertical,
                  //   lineXY: 0.1,
                  //   isFirst: true,
                  //   indicatorStyle: const IndicatorStyle(
                  //     width: 20,
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //     padding: EdgeInsets.all(6),
                  //   ),
                  //   endChild: const Text(
                  //       'Sake well and secure the cap with tap ',
                  //       style: TextStyle(fontSize: 16)),
                  //   beforeLineStyle: const LineStyle(
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //   ),
                  //   afterLineStyle: const LineStyle(
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //   ),
                  // ),
                  // TimelineTile(
                  //   alignment: TimelineAlign.manual,
                  //   lineXY: 0.1,
                  //   isFirst: true,
                  //   indicatorStyle: const IndicatorStyle(
                  //     width: 20,
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //     padding: EdgeInsets.all(6),
                  //   ),
                  //   endChild: const Text(
                  //       'Light a bottles with a phone torch with the back ',
                  //       style: TextStyle(fontSize: 16)),
                  //   beforeLineStyle: const LineStyle(
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //   ),
                  // ),
                  // TimelineTile(
                  //   alignment: TimelineAlign.manual,
                  //   lineXY: 0.1,
                  //   isFirst: true,
                  //   indicatorStyle: const IndicatorStyle(
                  //     width: 20,
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //     padding: EdgeInsets.all(6),
                  //   ),
                  //   endChild: const Text(
                  //       'Absorve as Ali is amoused with the bright contarct in colors ',
                  //       style: TextStyle(fontSize: 16)),
                  //   beforeLineStyle: const LineStyle(
                  //     color: Color.fromARGB(255, 145, 150, 147),
                  //   ),
                  // ),
                ],
              ),
            ],
          )
          :const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 15,
        width: double.infinity,
        color: const Color.fromARGB(255, 225, 225, 224),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(onTap: favorite,child: Icon(f == 1? Icons.favorite : Icons.favorite_border_outlined)),
            InkWell(onTap: complete,child: Icon(c == 1? Icons.check_circle : Icons.check_circle_outline)),
            const Text(
              'Mark as completed',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Icon(Icons.share),
            const Icon(Icons.savings_rounded)
          ],
        ),
      ),
    );
  }

  void favorite() async {
    setState(() {
      f= f==0?1:0;
    });
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('http://13.127.11.171:3000/activities/favorite'));
    request.bodyFields = {
      'childId': '1',
      'activityId': widget.id.toString(),
      'type':f.toString()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  void complete() async {
    setState(() {
      c= c==0?1:0;
    });
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('http://13.127.11.171:3000/activities/complete'));
    request.bodyFields = {
      'childId': '1',
      'activityId': widget.id.toString(),
      'type':c.toString()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }
}



//