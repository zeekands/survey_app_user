import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:survey_app_user/app/modules/home/views/home_view.dart';
import 'package:survey_app_user/app/routes/app_pages.dart';
import 'package:survey_app_user/app/utils/get_storage.dart';

import '../controllers/survey_answer_controller.dart';

class SurveyAnswerView extends GetView<SurveyAnswerController> {
  const SurveyAnswerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:
            const Text('Survey Results', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              box.erase();
              Get.offAllNamed(Routes.LOGIN);
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      drawer: getDrawer(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo_umb.jpg",
                width: 200,
              ),
              const SizedBox(height: 50),
              const Text(
                  "Selamat Datang\n Berikan penilaian jujur anda pada setiap pertanyaan berikut:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              const Text(
                "skala 1 sangat tidak berjalan sesuai kebutuhan, hingga skala 5 sangat berjalan sesuai ekspektasi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.HOME);
                  },
                  child: const Text("Mulai Survey"))
            ],
          ).paddingSymmetric(
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
