class SurveyAnswer {
  final String id;
  final String createdAt;
  final String name;
  final String percentage;
  final String result;
  final String desc;

  SurveyAnswer({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.percentage,
    required this.result,
    required this.desc,
  });

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) {
    return SurveyAnswer(
      id: json['id'],
      createdAt: json['createdAt'],
      name: json['name'],
      percentage: json['percentage'],
      result: json['result'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'percentage': percentage,
      'result': result,
      'desc': desc,
    };
  }
}
