import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_app_user/app/utils/get_storage.dart';
import 'package:survey_app_user/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute:
          box.read(isLogin) == true ? Routes.SURVEY_ANSWER : AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
