// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({Key? key}) : super(key: key);

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                  "Selamat Datang. Berikan penilaian jujur anda pada setiap pertanyaan berikut:"),
              const SizedBox(height: 20),
              const Text(
                  "skala 1 sangat tidak berjalan sesuai kebutuhan, hingga skala 5 sangat berjalan sesuai ekspektasi"),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Mulai Survey"))
            ],
          ),
        ),
      ),
    );
  }
}
