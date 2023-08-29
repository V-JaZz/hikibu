import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/home_screen/bottomnavigate.dart';
import 'package:hukibu/model/activities_data.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
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
  int f = 0;
  int c = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var url = Uri.parse('http://139.59.68.139:3000/getActivity/${widget.id}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(activityModel.toString());
      setState(() {
        activityModel = ActivityModel.fromJson(jsonResponse);
      });
      List<String> a = StorageService.to.getList(activityModel!.activity!.id.toString());
      f = int.tryParse(a.first)??0;
      c = int.tryParse(a.last)??0;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activityModel!=null
          ? SingleChildScrollView(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.8,
                  width: MediaQuery.of(context).size.width / 1,
                  child: Image.network(
                    'http://139.59.68.139:3000/uploads/${activityModel!.activity?.image}',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    color: const Color.fromARGB(85, 0, 0, 0),
                    filterQuality: FilterQuality.high,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                20.heightBox,
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    // 'Sensory Bottles',
                   '${activityModel!.activity?.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    // 'Sensory Bottles',
                    '${activityModel!.activity?.description}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16),
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
                        '${activityModel!.activity!.timeDuration} min',
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
                  width: double.infinity,
                  color: const Color.fromARGB(255, 217, 216, 216),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Materials needed'.tr(),
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 3),
                        for (int index = 0;
                        index <
                            (activityModel?.materialData?.length ?? 0);
                        index++)
                          Text(
                            ' - ${activityModel!.materialData![index]
                                .materialName ??
                                ''}',
                            style: const TextStyle(fontSize: 18),
                          ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: List.generate(activityModel?.stepData?.length ?? 0, (index) {
                    final stepData = activityModel?.stepData![index];
                    return TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      isFirst: true,
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Color.fromARGB(255, 145, 150, 147),
                        padding: EdgeInsets.all(6),
                      ),
                      // endChild: Text('\n${stepData?.title ?? 'dfsd'}\n${stepData?.stepDescription ?? ''}',
                      //     style: const TextStyle(fontSize: 16)),
                      endChild: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '${stepData?.title ?? 'No Title'}\n',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: stepData?.stepDescription ?? 'null description',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                )
                              ]),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                'http://139.59.68.139:3000/uploads/${stepData?.image}',
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(248, 188, 187, 187),
                                    highlightColor: Colors.white,
                                    period: const Duration(seconds: 1),
                                    child: Container(
                                      color: Colors.white,
                                      height:Get.width * 0.25,
                                      width: Get.width * 0.42,
                                    ),
                                  );
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      beforeLineStyle: const LineStyle(
                        color: Color.fromARGB(255, 145, 150, 147),
                      ),
                    );
                  }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12)
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
      ),
          )
      :const Center(
        child: CircularProgressIndicator(),
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
            Text(
              'Mark as completed'.tr(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            GestureDetector(onTap: (){

              String linkToShare = 'https://www.example.com/activity1';
              Share.share(linkToShare);
            },
                child: const Icon(Icons.share)),
            // const Icon(Icons.savings_rounded)
          ],
        ),
      ),
    );
  }

  void favorite() {
    setState(() {
      f==0?f=1:f=0;
    });
    StorageService.to.setList(activityModel!.activity!.id.toString(), [f.toString(),c.toString()]);
    // setState(() {
    //   f= f==0?1:0;
    // });
    // var headers = {
    //   'Content-Type': 'application/x-www-form-urlencoded'
    // };
    // var request = http.Request('POST', Uri.parse('http://139.59.68.139:3000/activities/favorite'));
    // request.bodyFields = {
    //   'childId': '1',
    //   'activityId': widget.id.toString(),
    //   'type':f.toString()
    // };
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();
    //
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    // else {
    //   print(response.reasonPhrase);
    // }

  }

  void complete() async {
    setState(() {
      c==0?c=1:c=0;
    });
    StorageService.to.setList(activityModel!.activity!.id.toString(), [f.toString(),c.toString()]);
    // setState(() {
    //   c= c==0?1:0;
    // });
    // var headers = {
    //   'Content-Type': 'application/x-www-form-urlencoded'
    // };
    // var request = http.Request('POST', Uri.parse('http://139.59.68.139:3000/activities/complete'));
    // request.bodyFields = {
    //   'childId': '1',
    //   'activityId': widget.id.toString(),
    //   'type':c.toString()
    // };
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();
    //
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    // else {
    //   print(response.reasonPhrase);
    // }

  }
}



//