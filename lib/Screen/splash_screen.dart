import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hukibu/API/api_client.dart';
import 'package:hukibu/routes/route_paths.dart';

import '../model/on_boarding_model.dart';
import '../services/storage.dart';
import 'auth_screen/onbording_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  OnBoardingModel onBoard = OnBoardingModel();

  @override
  void initState() {
    super.initState();
    String userTokenKey = 'userTokenKey';
    ApiClient.to.token = StorageService.to.getString(userTokenKey);
    Future.delayed(const Duration(seconds: 1), () {
      print('token \'${ApiClient.to.token}\'');
      if (ApiClient.to.token == '') {
        onBoardingInit();
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(RoutePaths.homeScreen);
        });
      }
    });
  }


  Future<OnBoardingModel> getOnBoarding() async {

    var response = await http.get(Uri.parse('http://139.59.68.139:3000/admin-get-all-intropage'));

    if (response.statusCode == 200) {
      onBoard = onBoardingModelFromJson(response.body);
    }
    else {
      print(response.reasonPhrase);
      onBoard = OnBoardingModel(success: false);
    }
    return onBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(58.0),
          child: Image.asset('assets/images/back.png'),
        ),
      ),
    );
  }

  void onBoardingInit() async {
    onBoard = await getOnBoarding();
    Get.offAll(()=> OnboardingScreen(onBoard: onBoard));
  }
}
