import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hukibu/routes/route_paths.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:velocity_x/velocity_x.dart';

import '../getx_helper/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 28.0),
            child: Text(
              'Hukibu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          const Center(
            child: Text('English'),
          ),
          Switch(
            onChanged: (val) {
              controller.toggleSwitch(val);
            },
            value: context.locale.toString() == 'en_US' ? false : true,
            activeColor: Colors.purpleAccent,
            activeTrackColor: Colors.purple,
            inactiveThumbColor: Colors.deepPurple,
            inactiveTrackColor: Colors.deepPurpleAccent,
          ),
          const Center(
            child: Text('Turkish'),
          ),
          8.widthBox
        ],
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Enter Your Phone Number',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.all(18),
              color: const Color.fromARGB(255, 232, 230, 230),
              child: InternationalPhoneNumberInput(
                initialValue: controller.number,
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  controller.phoneNo = number.phoneNumber;
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.black),
                // initialValue: number,
                // textFieldController: controller,
                formatInput: false,
                inputDecoration: const InputDecoration(
                  filled: false,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x38000000)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                cursorColor: Colors.transparent,
                hintText: "Enter your mobile number",
                spaceBetweenSelectorAndTextField: 1,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSaved: (PhoneNumber number) {
                  print("LenghtNumber ${number.phoneNumber!.length}");
                  // if (number.phoneNumber!.length == 13) {
                    // print(' Saved Phone: $number');
                  //   setState(() {
                  //     buttonText = 'Sending OTP...';
                  //   });
                  //   sentStatus(number.phoneNumber.toString());
                  //
                  // } else {
                  //   print(' Saved Invalidate : $number');
                  //   formKey.currentState!.validate();
                  // }
                },
                validator: (p0) {
                  if(controller.phoneNo?.length == 13){
                    return null;
                  }
                  return "Invalid Phone Number";
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () =>  InkWell(
                onTap: () {
                  if(controller.isLoading.value == false && _formKey.currentState!.validate()){
                    controller.sendLoginOTP();
                  }
                  //  Get.offAllNamed(RoutePaths.homeScreen);
                  // Get.toNamed(RoutePaths.otpVerificationScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 103, 43, 215),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            :const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 80.0, right: 80),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       InkWell(
            //         onTap: () {
            //           controller.signInWithGoogle();
            //         },
            //         child: CircleAvatar(
            //           backgroundColor: const Color.fromARGB(255, 237, 233, 233),
            //           radius: 20,
            //           child: Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: Image.asset(
            //               'assets/images/gmail.png',
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           controller.signInWithFacebook();
            //         },
            //         child: CircleAvatar(
            //           backgroundColor: const Color.fromARGB(255, 237, 233, 233),
            //           radius: 22,
            //           child: Padding(
            //             padding: const EdgeInsets.all(4.0),
            //             child: Image.asset('assets/images/facebook.png'),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 15,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           controller.signInWithTwitter();
            //         },
            //         child: CircleAvatar(
            //           backgroundColor: const Color.fromARGB(255, 237, 233, 233),
            //           radius: 22,
            //           child: Padding(
            //             padding: const EdgeInsets.all(4.0),
            //             child: Image.asset('assets/images/twitter.png'),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Don't have a account ",
                  children: [
                    TextSpan(
                      text: "Register?",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(RoutePaths.createAccount);
                        },
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
