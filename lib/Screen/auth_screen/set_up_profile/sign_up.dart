// ignore_for_file: body_might_complete_normally_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hukibu/Screen/auth_screen/email_auth/login_screen.dart';
import 'package:hukibu/model/user_model.dart';
import 'package:hukibu/routes/route_paths.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../home_screen/bottomnavigate.dart';
import '../getx_helper/auth_controller.dart';

class SignUpScreen extends GetView<AuthController> {
  SignUpScreen({super.key});

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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Complete your profile Sign up',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Enter the following details',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
              //   height: MediaQuery.of(context).size.height / 2.3,
                width: double.infinity,
                color: const Color.fromARGB(255, 223, 221, 221),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                      child: TextFormField(
                        controller: controller.usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Username',
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Username Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'email Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
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
                    SizedBox(height: 12)
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20),
                    //   child: TextFormField(
                    //     obscureText: true,
                    //     controller: controller.passwordController,
                    //     decoration: const InputDecoration(
                    //       hintText: 'Enter Your Password',
                    //       labelText: 'Password',
                    //     ),
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Password Required';
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await controller.signUp();
                  }
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
                    child: const Center(
                      child: Text(
                        'Verify',
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
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Don't have a account ",
                    children: [
                      TextSpan(
                        text: "Login?",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offAllNamed(RoutePaths.loginScreen);
                          },
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
