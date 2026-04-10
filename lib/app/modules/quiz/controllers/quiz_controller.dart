import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bab_model.dart';
import '../../../data/models/latihan_model.dart';

enum AnswerStatus { none, correct, incorrect }

class QuizController extends GetxController {
  late final Bab bab;

  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final Rx<AnswerStatus> answerStatus = AnswerStatus.none.obs;
  final RxBool isFinished = false.obs;
  final RxBool showFeedback = false.obs;
  final RxString feedbackMessage = ''.obs;

  List<Latihan> get questions => bab.latihan ?? [];
  Latihan? get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex.value] : null;
  int get totalQuestions => questions.length;

  @override
  void onInit() {
    super.onInit();
    bab = Get.arguments as Bab;
  }

  void answerQuestion(bool userAnswer) {
    if (showFeedback.value) return;
    final question = currentQuestion;
    if (question == null) return;

    final bool isCorrect = question.jawaban == userAnswer;
    if (isCorrect) {
      score.value++;
      answerStatus.value = AnswerStatus.correct;
    } else {
      answerStatus.value = AnswerStatus.incorrect;
    }
    feedbackMessage.value = question.penjelasan ?? '';
    showFeedback.value = true;
  }

  void nextQuestion() {
    showFeedback.value = false;
    answerStatus.value = AnswerStatus.none;

    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
    } else {
      isFinished.value = true;
    }
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    answerStatus.value = AnswerStatus.none;
    showFeedback.value = false;
    isFinished.value = false;
    feedbackMessage.value = '';
  }

  String get resultLabel {
    final pct = (score.value / totalQuestions) * 100;
    if (pct >= 90) return 'Luar Biasa! 🌟';
    if (pct >= 70) return 'Bagus! 👍';
    if (pct >= 50) return 'Cukup Baik 😊';
    return 'Perlu Belajar Lagi 📚';
  }

  Color get resultColor {
    final pct = (score.value / totalQuestions) * 100;
    if (pct >= 90) return const Color(0xFF1B5E20);
    if (pct >= 70) return const Color(0xFF0D47A1);
    if (pct >= 50) return const Color(0xFFF57F17);
    return const Color(0xFFB71C1C);
  }
}
