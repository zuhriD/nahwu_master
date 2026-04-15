import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/bab_model.dart';
import '../../../data/models/latihan_model.dart';
import '../../home/controllers/home_controller.dart';

enum AnswerStatus { none, correct, incorrect }

class QuizController extends GetxController {
  late final Bab bab;
  final StorageService _storage = Get.find<StorageService>();

  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final Rx<AnswerStatus> answerStatus = AnswerStatus.none.obs;
  final RxBool isFinished = false.obs;
  final RxBool showFeedback = false.obs;
  final RxString feedbackMessage = ''.obs;

  // Multiple choice state
  final RxInt selectedOptionIndex = (-1).obs;

  // Isian state
  final TextEditingController isianController = TextEditingController();
  final RxString isianAnswer = ''.obs;

  // Cocokkan state
  final RxMap<String, String> matchedPairs = <String, String>{}.obs;
  final Rxn<String> selectedLeftItem = Rxn<String>();
  final RxList<String> shuffledRightItems = <String>[].obs;
  final RxList<String> availableRightItems = <String>[].obs;

  // Achievement popup
  final RxList<Map<String, dynamic>> newAchievements = <Map<String, dynamic>>[].obs;

  List<Latihan> get questions => bab.latihan ?? [];
  Latihan? get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex.value] : null;
  int get totalQuestions => questions.length;

  @override
  void onInit() {
    super.onInit();
    bab = Get.arguments as Bab;
    _prepareCurrentQuestion();
  }

  @override
  void onClose() {
    isianController.dispose();

    // Refresh HomeController agar unlock status ter-update
    try {
      Get.find<HomeController>().refreshStats();
    } catch (_) {}

    super.onClose();
  }

  /// Siapkan state khusus untuk soal saat ini
  void _prepareCurrentQuestion() {
    final q = currentQuestion;
    if (q == null) return;

    if (q.tipe == 'cocokkan' && q.pasangan != null) {
      matchedPairs.clear();
      selectedLeftItem.value = null;
      final rightItems = q.pasangan!.values.toList()..shuffle();
      shuffledRightItems.value = rightItems;
      availableRightItems.value = List.from(rightItems);
    }

    if (q.tipe == 'isian') {
      isianController.clear();
      isianAnswer.value = '';
    }
  }

  /// Jawab soal benar/salah
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

  /// Jawab soal pilihan ganda
  void answerMultipleChoice(int selectedIndex) {
    if (showFeedback.value) return;
    final question = currentQuestion;
    if (question == null) return;

    selectedOptionIndex.value = selectedIndex;
    final bool isCorrect = selectedIndex == question.jawabanBenarIndex;

    if (isCorrect) {
      score.value++;
      answerStatus.value = AnswerStatus.correct;
    } else {
      answerStatus.value = AnswerStatus.incorrect;
    }
    feedbackMessage.value = question.penjelasan ?? '';
    showFeedback.value = true;
  }

  /// Submit jawaban isian
  void submitIsian() {
    if (showFeedback.value) return;
    final question = currentQuestion;
    if (question == null || question.jawabanIsian == null) return;

    final userAnswer = isianController.text.trim().toLowerCase();
    final correctAnswer = question.jawabanIsian!.trim().toLowerCase();

    final bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      score.value++;
      answerStatus.value = AnswerStatus.correct;
      feedbackMessage.value = question.penjelasan ?? 'Jawaban Anda benar!';
    } else {
      answerStatus.value = AnswerStatus.incorrect;
      feedbackMessage.value =
          'Jawaban yang benar: "${question.jawabanIsian}"${question.penjelasan != null ? '\n${question.penjelasan}' : ''}';
    }
    showFeedback.value = true;
  }

  // ── Cocokkan logic ──

  /// Pilih item kiri (istilah)
  void selectLeftItem(String item) {
    if (showFeedback.value) return;
    if (matchedPairs.containsKey(item)) return; // Sudah dicocokkan
    selectedLeftItem.value = item;
  }

  /// Pilih item kanan (jawaban) untuk dicocokkan dengan item kiri
  void selectRightItem(String item) {
    if (showFeedback.value) return;
    if (selectedLeftItem.value == null) return;
    if (!availableRightItems.contains(item)) return;

    matchedPairs[selectedLeftItem.value!] = item;
    availableRightItems.remove(item);
    selectedLeftItem.value = null;

    // Cek apakah sudah semua dicocokkan
    final question = currentQuestion;
    if (question?.pasangan != null &&
        matchedPairs.length == question!.pasangan!.length) {
      _checkMatchingResult();
    }
  }

  /// Hapus pasangan yang sudah dicocokkan (undo)
  void unmatchPair(String leftItem) {
    if (showFeedback.value) return;
    final rightItem = matchedPairs[leftItem];
    if (rightItem != null) {
      matchedPairs.remove(leftItem);
      availableRightItems.add(rightItem);
    }
  }

  /// Validasi hasil cocokkan
  void _checkMatchingResult() {
    final question = currentQuestion;
    if (question?.pasangan == null) return;

    int correctCount = 0;
    final totalPairs = question!.pasangan!.length;

    for (final entry in question.pasangan!.entries) {
      if (matchedPairs[entry.key] == entry.value) {
        correctCount++;
      }
    }

    final bool allCorrect = correctCount == totalPairs;

    if (allCorrect) {
      score.value++;
      answerStatus.value = AnswerStatus.correct;
      feedbackMessage.value =
          question.penjelasan ?? 'Semua pasangan benar! 🎉';
    } else {
      answerStatus.value = AnswerStatus.incorrect;
      // Bangun pesan koreksi
      final wrongPairs = <String>[];
      for (final entry in question.pasangan!.entries) {
        if (matchedPairs[entry.key] != entry.value) {
          wrongPairs.add('${entry.key} → ${entry.value}');
        }
      }
      feedbackMessage.value =
          'Benar: $correctCount/$totalPairs\nKoreksi: ${wrongPairs.join(', ')}';
    }
    showFeedback.value = true;
  }

  void nextQuestion() {
    showFeedback.value = false;
    answerStatus.value = AnswerStatus.none;
    selectedOptionIndex.value = -1;
    isianController.clear();
    isianAnswer.value = '';
    matchedPairs.clear();
    selectedLeftItem.value = null;

    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
      _prepareCurrentQuestion();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    isFinished.value = true;

    // Simpan hasil ke storage
    if (bab.id != null) {
      // Snapshot achievements sebelum save
      final beforeUnlocked = _storage.getUnlockedAchievements().toSet();

      _storage.saveQuizResult(bab.id!, score.value, totalQuestions);

      // Cek achievement baru
      final afterUnlocked = _storage.getUnlockedAchievements().toSet();
      final newOnes = afterUnlocked.difference(beforeUnlocked);

      if (newOnes.isNotEmpty) {
        for (final id in newOnes) {
          final achievement = StorageService.allAchievements
              .firstWhereOrNull((a) => a['id'] == id);
          if (achievement != null) {
            newAchievements.add(achievement);
          }
        }
      }
    }
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    answerStatus.value = AnswerStatus.none;
    showFeedback.value = false;
    isFinished.value = false;
    feedbackMessage.value = '';
    selectedOptionIndex.value = -1;
    isianController.clear();
    isianAnswer.value = '';
    matchedPairs.clear();
    selectedLeftItem.value = null;
    newAchievements.clear();
    _prepareCurrentQuestion();
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

  /// XP yang didapat dari quiz ini
  int get earnedXp {
    final double pct = score.value / totalQuestions * 100;
    if (pct == 100) return 100;
    if (pct >= 80) return 50;
    if (pct >= 60) return 30;
    return 10;
  }
}
