import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hukibu/services/firebase.dart';
import 'package:hukibu/services/user.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:http/http.dart'as http;
import '../../../API/api_client.dart';
import '../../../routes/route_paths.dart';

class AuthController extends GetxController {
  Rx<int> seconds = 60.obs;
  Rx<bool> isLoading = false.obs;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<String> otpController = ''.obs;
  final TextEditingController countryCode = TextEditingController();
  String uid = '';
  RxBool isValid = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? phoneNo;
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  sendLoginOTP() async {
    isLoading.value = true;
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('http://139.59.68.139:3000/login'));
    request.bodyFields = {
      "mobile": phoneNo!.trim()
    };
    print(request.toString());
    print(jsonEncode(request.bodyFields));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 30));
    print(response.statusCode);

    isLoading.value = false;

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
      Get.toNamed(RoutePaths.otpVerificationScreen);
    }
    else {
      Fluttertoast.showToast(
        msg: response.reasonPhrase??"error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<void> signIn() async {
    Response res = await ApiClient.to.postData(
      'http://139.59.68.139:3000/user/login',
        {
          "username": emailController.text,
          "password": passwordController.text
        }
    );
    log('This is the email auth response: ${res.body}');
    if (res.body['status'] == true) {
      uid = res.body['uid'];
      UserStore.to.saveProfile(uid);
      UserStore.to.setToken(res.body['token']);
      Get.offAllNamed(RoutePaths.homeScreen);
    } else {
      Fluttertoast.showToast(
        msg: "Unknown error occurred",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  validateOtp() async {

      isLoading.value = true;

      Response res = await ApiClient.to.postData(
          'http://139.59.68.139:3000/verifyPhoneOtp',
          {
            "mobile": phoneNo!.trim(),
            "otp": otpController.value
          }
      );
      print({
        "mobile": phoneNo!.trim(),
        "otp": otpController.value
      });

    isLoading.value = false;
    if (res.statusCode == 200 && res.body["succee"]==1) {
      debugPrint(res.body["data"]['id'].toString());
      debugPrint(res.body.toString());
      ApiClient.to.token = res.body["data"]['id'].toString();
      await UserStore.to.saveProfile(res.body["data"]['id'].toString());
      await UserStore.to.setToken(res.body["data"]['id'].toString());
      await FirebaseFireStore.to.addUser(
          UserStore.to.profile
      );
      Get.offAllNamed(RoutePaths.homeScreen);
            return true;
    }
    else {
      print(res.body);
            Get.snackbar(
              'Error',
              'The input OTP is either invalid or expired',
              snackStyle: SnackStyle.FLOATING,
              icon: const Icon(
                Icons.person,
                color: Color(0xff28282B),
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.grey[200],
              borderRadius: 10.r,
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.all(15.w),
              colorText: const Color(0xff28282B),
              duration: const Duration(seconds: 4),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
            );
    }
  }

  validatePhoneNumber() {
    isValid.value = (int.tryParse(phoneNumber.text) != null) &&
        phoneNumber.text.length == 10;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      Get.offAllNamed(RoutePaths.homeScreen);
      if (kDebugMode) {
        print("Signed in as ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with Google: $e");
      }
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      User? user = (await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)).user;
      Get.offAllNamed(RoutePaths.homeScreen);
      if (kDebugMode) {
        print("Signed in as ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with facebook: $e");
      }
    }
  }

  Future<void> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: '<your consumer key>',
        apiSecretKey: ' <your consumer secret>',
        redirectURI: '<your_scheme>://',
      );
      final authResult = await twitterLogin.login();

      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );
      User? user = (await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential)).user;
      Get.offAllNamed(RoutePaths.homeScreen);
      if (kDebugMode) {
        print("Signed in as ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with facebook: $e");
      }
    }
  }

  Future<void> signUp() async {
      try {
        Response res = await ApiClient.to.postData(
            'http://139.59.68.139:3000/signUp',
            {
              "username":usernameController.text,
              "mobile":phoneNo!.trim(),
              "email":emailController.text
            }
        );
        print({
          "username":usernameController.text,
          "mobile":phoneNo!.trim(),
          "email":emailController.text
        });
        // isLoading.value = false;
        log('This is the signUp response: ${res.body}');
        print(res.statusCode);
        if (res.statusCode==200) {
          // UserStore.to.saveProfile(res.body['uid']);
          // UserStore.to.setToken(res.body['token']);
          // Get.toNamed(RoutePaths.otpVerificationScreen);

          // debugPrint(res.body["data"]['id'].toString());
          // debugPrint(res.body.toString());
          // ApiClient.to.token = res.body["data"]['id'].toString();
          // await UserStore.to.saveProfile(res.body["data"]['id'].toString());
          // await UserStore.to.setToken(res.body["data"]['id'].toString());

          // Get.offAllNamed(RoutePaths.homeScreen);

          Get.toNamed(RoutePaths.otpVerificationScreen);

        } else {
          Get.snackbar(
            "Error",
            '${res.body}',
            snackStyle: SnackStyle.FLOATING,
            icon: const Icon(
              Icons.person,
              color: Color(0xff28282B),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey[200],
            borderRadius: 10.r,
            margin: EdgeInsets.all(10.w),
            padding: EdgeInsets.all(15.w),
            colorText: const Color(0xff28282B),
            duration: const Duration(seconds: 4),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
          );
        }
      } catch (error) {
        isLoading.value = false;
        Get.snackbar(
          "Auth Failed",
          'The input OTP is either invalid or expired',
          snackStyle: SnackStyle.FLOATING,
          icon: const Icon(
            Icons.person,
            color: Color(0xff28282B),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[200],
          borderRadius: 10.r,
          margin: EdgeInsets.all(10.w),
          padding: EdgeInsets.all(15.w),
          colorText: const Color(0xff28282B),
          duration: const Duration(seconds: 4),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    }
}
