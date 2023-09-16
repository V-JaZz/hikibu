import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/routes/route_paths.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../model/on_boarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  final OnBoardingModel onBoard;
  const OnboardingScreen({super.key, required this.onBoard});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: IntroductionScreen(
        // key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        autoScrollDuration: 3000,
        globalHeader: const Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16, right: 16),
            ),
          ),
        ),
        globalFooter: Container(
          width: 300,
          height: 52,
          margin: EdgeInsets.only(bottom: 10.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 103, 43, 215),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Get.offAllNamed(RoutePaths.loginScreen);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 80.w),
                  child: Text('Get Started'.tr()),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20.h,
                  ),
                ),
              ],
            ),
          ),
        ),
        pages: List.generate(widget.onBoard.data?.length??0, (index) =>
            PageViewModel(
              title: widget.onBoard.data![index].title,
              body: widget.onBoard.data![index].description,
              image: Image.network(
                  'http://139.59.68.139:3000/uploads/${widget.onBoard.data?[index].image ?? ''}',
                  width: 350),
              decoration: pageDecoration,
            )),
        onDone: () {},
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
  }
}
