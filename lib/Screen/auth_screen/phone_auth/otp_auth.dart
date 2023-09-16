import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../getx_helper/auth_controller.dart';

class OTPScreen extends GetView<AuthController> {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Image.asset('assets/images/celebrating.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Enter OTP'.tr(),
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          OTPTextField(
            width: 250,
            length: 6,
            fieldWidth: 40,
            fieldStyle: FieldStyle.box,
            keyboardType: TextInputType.number,
            otpFieldStyle: OtpFieldStyle(
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              enabledBorderColor: Colors.black,
            ),
            onCompleted: (pin){
              controller.otpController.value = pin;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(
            () => InkWell(
              onTap: () {
                controller.validateOtp();
                // Get.offAllNamed(RoutePaths.homeScreen);
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
                          ?const CircularProgressIndicator(
                        color: Colors.white,
                      )
                      :Text(
                        'Verify'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
