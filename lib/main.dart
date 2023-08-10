import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hukibu/routes/route_paths.dart';
import 'package:hukibu/routes/routes.dart';
import 'package:hukibu/services/firebase.dart';
import 'package:hukibu/services/storage.dart';
import 'package:hukibu/services/user.dart';

import 'API/api_client.dart';
import 'Screen/chat_screen/getx_helper/recent_chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDFkXbxyxSZxJeVcNDa6VBxXnt86Tt3Z9A',
        appId: '1:1095020102252:web:ed394e3041e5898df44e49',
        messagingSenderId: '1095020102252',
        projectId: 'hukibu-322e6',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  Get.put(ApiClient());
  Get.put(FirebaseFireStore());
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<UserStore>(UserStore());
  Get.put(RecentChatController());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return GetMaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: RoutePaths.splashScreen,
        // initialRoute: RoutePaths.homeScreen,
        getPages: RouteClass.routes,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
