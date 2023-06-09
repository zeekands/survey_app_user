import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:survey_app_user/app/data/question_model.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('question');
  final refResult = FirebaseFirestore.instance.collection('results');

  Stream<List<QuestionModel>> readQuestion() {
    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) =>
                    QuestionModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Future<void> addResult(String name, String percentage, String result) async {
    final refDoc = refResult.doc();
    final data = {
      'id': refDoc.id,
      'name': name,
      'percentage': percentage,
      'result': result,
      'createdAt': DateTime.now().toString(),
    };
    await refDoc.set(data);
  }
}
