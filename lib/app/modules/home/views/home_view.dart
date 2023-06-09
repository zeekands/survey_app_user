import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:survey_app_user/app/data/question_model.dart';
import 'package:survey_app_user/app/routes/app_pages.dart';
import 'package:survey_app_user/app/utils/get_storage.dart';
import 'package:survey_kit/survey_kit.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
        title: const Text('Survey App', style: TextStyle(color: Colors.black)),
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
      body: StreamBuilder<List<QuestionModel>>(
          stream: controller.readQuestion(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              var list = <QuestionStep>[];
              for (var i = 0; i < data.length; i++) {
                list.add(QuestionStep(
                    title: data[i].title,
                    answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                      TextChoice(text: "1", value: "1"),
                      TextChoice(text: "2", value: "2"),
                      TextChoice(text: "3", value: "3"),
                      TextChoice(text: "4", value: "4"),
                      TextChoice(text: "5", value: "5"),
                    ])));
              }
              return SurveyKit(
                themeData: getTheme(context),
                surveyProgressbarConfiguration: SurveyProgressConfiguration(
                  backgroundColor: Colors.black,
                ),
                task: NavigableTask(
                  id: TaskIdentifier(id: "1"),
                  steps: [
                    ...list,
                    CompletionStep(
                        stepIdentifier: StepIdentifier(id: '321'),
                        text:
                            'Thanks for taking the survey, we will contact you soon!',
                        title: 'Done!',
                        buttonText: 'Submit survey',
                        isOptional: true),
                  ],
                ),
                onResult: (data) async {
                  var countData = data.results.length;
                  var sumAll = 0;
                  //var sumNo = 0;
                  data.results.removeAt(countData - 1);
                  var result = data.results;
                  print(data.results.length);

                  for (var i = 0; i < countData - 1; i++) {
                    sumAll += int.parse(
                        result[i].results[0].valueIdentifier.toString());
                  }
                  print(sumAll);
                  final resultPercentage =
                      (((sumAll / (5 * (countData - 1))) / 100) * 100) * 100;
                  var resultPercentageString =
                      resultPercentage.toStringAsFixed(2);
                  var conclution = "";

                  if (resultPercentage <= 10) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sangat tidak optimal";
                  } else if (resultPercentage <= 20) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sangat rendah";
                  } else if (resultPercentage <= 30) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sangat buruk";
                  } else if (resultPercentage <= 40) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang buruk";
                  } else if (resultPercentage <= 50) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sedang";
                  } else if (resultPercentage <= 60) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang cukup baik";
                  } else if (resultPercentage <= 70) {
                    conclution = "Sistem memiliki tingkat kematangan yang baik";
                  } else if (resultPercentage <= 80) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sangat baik";
                  } else if (resultPercentage <= 90) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang sangat tinggi";
                  } else if (resultPercentage <= 100) {
                    conclution =
                        "Sistem memiliki tingkat kematangan yang optimal";
                  }
                  print(resultPercentageString);
                  print(conclution);

                  //  sumYes / 5(5 * 5);
                  // if (resultPercentage >= 50) {
                  //   conclution = "Good";
                  // } else {
                  //   conclution = "Not Good";
                  // }
                  await controller.addResult(
                      box.read(userName), resultPercentageString, conclution);
                  Get.offNamed(Routes.SURVEY, arguments: [
                    resultPercentageString,
                    conclution,
                  ]);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

ThemeData getTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    primaryColor: Colors.cyan,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.cyan,
      ),
      titleTextStyle: TextStyle(
        color: Colors.cyan,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.cyan,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.cyan,
      selectionColor: Colors.cyan,
      selectionHandleColor: Colors.cyan,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: Colors.cyan,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          const Size(150.0, 60.0),
        ),
        side: MaterialStateProperty.resolveWith(
          (Set<MaterialState> state) {
            if (state.contains(MaterialState.disabled)) {
              return const BorderSide(
                color: Colors.grey,
              );
            }
            return const BorderSide(
              color: Colors.cyan,
            );
          },
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (Set<MaterialState> state) {
            if (state.contains(MaterialState.disabled)) {
              return Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey,
                  );
            }
            return Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.cyan,
                );
          },
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.cyan,
              ),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 28.0,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.0,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 18.0,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.cyan,
    )
        .copyWith(
          onPrimary: Colors.white,
        )
        .copyWith(background: Colors.white),
  );
}

Drawer getDrawer() {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://xsgames.co/randomusers/assets/avatars/male/70.jpg"),
              ),
              const SizedBox(height: 8),
              Text(
                box.read(userName),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                box.read(userEmail),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Survey'),
          onTap: () {
            Get.offAllNamed(Routes.SURVEY_ANSWER);
          },
        ),
        ListTile(
          leading: const Icon(Icons.assignment),
          title: const Text('Hasil Survei'),
          onTap: () {
            Get.offAllNamed(Routes.SURVEY);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profil'),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.PROFILE);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Keluar'),
          onTap: () {
            box.erase();
            Get.offAllNamed(Routes.LOGIN);
          },
        ),
      ],
    ),
  );
}
