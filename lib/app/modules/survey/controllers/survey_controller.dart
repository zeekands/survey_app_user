import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:survey_app_user/app/data/survey_answer_model.dart';
import 'package:survey_app_user/app/utils/get_storage.dart';

class SurveyController extends GetxController {
  final ref = FirebaseFirestore.instance.collection('results');

  Stream<List<SurveyAnswer>> readResult() {
    return ref.snapshots().map(
          (list) => list.docs
              .where((element) => element.data()['name'] == box.read(userName))
              .map(
                (doc) => SurveyAnswer.fromJson(doc.data()),
              )
              .toList(),
        );
  }
}
