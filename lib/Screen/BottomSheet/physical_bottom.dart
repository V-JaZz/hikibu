import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:velocity_x/velocity_x.dart';

Widget physicalBottom() {
  return SizedBox(
    height: 300,
    width: double.infinity,
    //decoration:c BoxDecoration(),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height / 7,
                // width: MediaQuery.of(context).size.width / 4.8,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.person),
                    Text(
                      'physical'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      endIndent: 20,
                      indent: 20,
                      thickness: 8,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Wonder! Child has met his social and emotional developmental milestones for the age. Help him continue the great journey with a lot of social playtime and fun'.tr(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        30.heightBox,
        TimelineTile(
          axis: TimelineAxis.vertical,
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: true,
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: Color.fromARGB(255, 145, 150, 147),
            padding: EdgeInsets.all(8),
          ),
          endChild: Text(
              'Social Ans International Skills- include all the skills that enable the child to interact with his/her surrounding and fellows humans'.tr(),
              style: const TextStyle(fontSize: 16)),
          beforeLineStyle: const LineStyle(
            color: Color.fromARGB(255, 145, 150, 147),
          ),
        ),
      ],
    ),
  );
}
