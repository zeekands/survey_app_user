import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:survey_app_user/app/data/survey_answer_model.dart';
import 'package:survey_app_user/app/modules/home/views/home_view.dart';
import 'package:survey_app_user/app/routes/app_pages.dart';
import 'package:survey_app_user/app/utils/get_storage.dart';

import '../controllers/survey_controller.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({Key? key}) : super(key: key);
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
      drawer: getDrawer(),
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
      body: StreamBuilder<List<SurveyAnswer>>(
        stream: controller.readResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.hasData) {
            final questionnaires = snapshot.data!;
            var listQuestionaire = <DataRow>[];
            for (int i = 0; i < questionnaires.length; i++) {
              var date = DateTime.parse(questionnaires[i].createdAt);
              var formatedDate = DateFormat('dd MMM yyyy').format(date);

              listQuestionaire.add(DataRow(cells: [
                DataCell(Text(
                  formatedDate,
                  style: const TextStyle(fontSize: 12),
                )),
                DataCell(Text(
                  questionnaires[i].name,
                  style: const TextStyle(fontSize: 12),
                )),
                DataCell(Text(
                  "${questionnaires[i].percentage}%",
                  style: const TextStyle(fontSize: 12),
                )),
                DataCell(Text(
                  questionnaires[i].result,
                  style: const TextStyle(fontSize: 12),
                )),
                const DataCell(Icon(
                  Icons.info,
                  size: 12,
                )),
              ]));
            }
            return Container(
              padding: const EdgeInsets.all(16),
              width: Get.width,
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Tanggal',
                      style: TextStyle(fontSize: 12),
                    )),
                    DataColumn(
                        label: Text('Nama', style: TextStyle(fontSize: 12))),
                    DataColumn(
                        label: Text('Hasil', style: TextStyle(fontSize: 12))),
                    DataColumn(
                        label: Text('Remark', style: TextStyle(fontSize: 12))),
                    DataColumn(
                        label: Text('Desc', style: TextStyle(fontSize: 12))),
                  ],
                  rows: listQuestionaire,
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}
