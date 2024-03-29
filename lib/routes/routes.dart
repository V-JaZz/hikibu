
import 'package:get/get.dart';
import 'package:hukibu/Screen/auth_screen/onbording_screen.dart';
import 'package:hukibu/Screen/auth_screen/phone_auth/otp_auth.dart';
import 'package:hukibu/Screen/auth_screen/set_up_profile/sign_up.dart';
import 'package:hukibu/Screen/chat_screen/getx_helper/chat_space_helper/chat_space_bindings.dart';
import 'package:hukibu/Screen/home_screen/home_screen.dart';
import 'package:hukibu/Screen/home_screen/bottomnavigate.dart';
import 'package:hukibu/routes/route_paths.dart';

import '../Screen/auth_screen/getx_helper/auth_binding.dart';
import '../Screen/auth_screen/email_auth/login_screen.dart';
import '../Screen/auth_screen/set_up_profile/profile_screen.dart';
import '../Screen/auth_screen/phone_auth/phone_auth.dart';
import '../Screen/chat_list.dart';
import '../Screen/home_screen/getx_helper/home_binding.dart';
import '../Screen/splash_screen.dart';

class RouteClass {


  static List<GetPage> routes = [

    ///Starting Showcase
    GetPage(
      name: RoutePaths.splashScreen,
      page: () => const SplashScreen(),
    ),

    ///Authentication Screen
    GetPage(
      name: RoutePaths.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutePaths.mobileVerifyScreen,
      page: () => const PhoneAuth(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutePaths.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutePaths.otpVerificationScreen,
      page: () => const OTPScreen(),
    ),


    ///OneTimeAuthScreens
    GetPage(
      name: RoutePaths.createAccount,
      page: () => SignUpScreen(),
    ),


    ///MainPages
    GetPage(
      name: RoutePaths.homeScreen,
      page: () => const BottomNavigator(),
      binding: HomeBinding()
    ),

    GetPage(
      name: ChatPage.routeName,
      page: () => const ChatPage(),
      binding: ChatSpaceBinding()
    ),

  ];
}