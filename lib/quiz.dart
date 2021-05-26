class Quiz {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Quiz({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    print("JSON FROM API: ${json['results']}");
    return Quiz(
        question: json['results'],
        options: json['options'],
        correctAnswer: json['correct']);
  }
}
