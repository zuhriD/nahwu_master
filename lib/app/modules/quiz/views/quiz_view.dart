import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color onPrimaryContainer = Color(0xFF7FBDA5);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color surfaceVariant = Color(0xFFE4E2DE);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.isFinished.value) return _buildResultScreen();
          return _buildQuizScreen();
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  QUIZ SCREEN
  // ══════════════════════════════════════════════════════════════

  Widget _buildQuizScreen() {
    return Column(
      children: [
        _buildHeader(),
        _buildProgressSection(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              children: [
                _buildQuestionCard(),
                const SizedBox(height: 24),
                Obx(() => controller.showFeedback.value
                    ? _buildFeedbackCard()
                    : _buildAnswerArea()),
              ],
            ),
          ),
        ),
        _buildFooterInfo(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back_rounded, color: primary),
              ),
              const SizedBox(width: 16),
              Text(
                'Latihan: ${controller.isBab ? "Bab" : "Sub Bab"} ${controller.data.id}',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          Obx(() {
            final current = controller.currentQuestionIndex.value + 1;
            final total = controller.totalQuestions;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: secondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '$current/$total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Obx(() {
      final current = controller.currentQuestionIndex.value;
      final total = controller.totalQuestions;
      final progress = total > 0 ? current / total : 0.0;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQuestionCard() {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question == null) return const SizedBox.shrink();

      final Map<String, dynamic> typeInfo = _getTypeInfo(question.tipe);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: onBackground.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: typeInfo['color'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(typeInfo['icon'] as IconData, color: Colors.white, size: 12),
                  const SizedBox(width: 6),
                  Text(
                    typeInfo['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              question.pertanyaan ?? '',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: primary,
              ),
            ),
          ],
        ),
      );
    });
  }

  Map<String, dynamic> _getTypeInfo(String tipe) {
    switch (tipe) {
      case 'pilihan_ganda':
        return {'label': 'PILIHAN GANDA', 'color': secondary, 'icon': Icons.list_rounded};
      case 'benar_salah':
        return {'label': 'BENAR / SALAH', 'color': primaryContainer, 'icon': Icons.check_circle_outline_rounded};
      case 'isian':
        return {'label': 'ISIAN', 'color': const Color(0xFF1565C0), 'icon': Icons.edit_rounded};
      case 'cocokkan':
        return {'label': 'COCOKKAN', 'color': const Color(0xFF6A1B9A), 'icon': Icons.compare_arrows_rounded};
      default:
        return {'label': tipe.toUpperCase(), 'color': onSurfaceVariant, 'icon': Icons.help_outline_rounded};
    }
  }

  /// Menentukan area jawaban berdasarkan tipe soal
  Widget _buildAnswerArea() {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question == null) return const SizedBox.shrink();

      switch (question.tipe) {
        case 'pilihan_ganda':
          return _buildMultipleChoiceOptions();
        case 'benar_salah':
          return _buildAnswerButtons();
        case 'isian':
          return _buildIsianInput();
        case 'cocokkan':
          return _buildCocokkanArea();
        default:
          return const SizedBox.shrink();
      }
    });
  }

  // ── Jawaban Isian ──

  Widget _buildIsianInput() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tulis jawaban Anda:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.isianController,
                textCapitalization: TextCapitalization.none,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Ketik jawaban...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: surfaceVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: surfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => controller.submitIsian(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Periksa Jawaban',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Jawaban Cocokkan ──

  Widget _buildCocokkanArea() {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question?.pasangan == null) return const SizedBox.shrink();

      final leftItems = question!.pasangan!.keys.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruksi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF6A1B9A).withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app_rounded, color: Color(0xFF6A1B9A), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap istilah kiri, lalu tap jawaban kanan yang sesuai',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF6A1B9A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Kolom kiri dan kanan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom KIRI — istilah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'ISTILAH',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    ...leftItems.map((item) => _buildLeftMatchItem(item)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Kolom KANAN — definisi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'DEFINISI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    ...controller.shuffledRightItems.map((item) => _buildRightMatchItem(item)),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildLeftMatchItem(String item) {
    return Obx(() {
      final isSelected = controller.selectedLeftItem.value == item;
      final isMatched = controller.matchedPairs.containsKey(item);
      final matchedWith = controller.matchedPairs[item];

      return GestureDetector(
        onTap: () {
          if (isMatched) {
            controller.unmatchPair(item);
          } else {
            controller.selectLeftItem(item);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isMatched
                ? const Color(0xFF6A1B9A).withValues(alpha: 0.1)
                : isSelected
                    ? primaryContainer
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isMatched
                  ? const Color(0xFF6A1B9A)
                  : isSelected
                      ? primaryContainer
                      : surfaceVariant,
              width: isSelected || isMatched ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : primary,
                ),
              ),
              if (isMatched) ...[
                const SizedBox(height: 4),
                Text(
                  '→ $matchedWith',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF6A1B9A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRightMatchItem(String item) {
    return Obx(() {
      final isAvailable = controller.availableRightItems.contains(item);
      final isMatched = !isAvailable;

      return GestureDetector(
        onTap: isAvailable ? () => controller.selectRightItem(item) : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isMatched ? 0.35 : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isMatched ? surfaceContainerLow : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isMatched ? surfaceVariant : const Color(0xFF6A1B9A).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              item,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isMatched ? onSurfaceVariant : primary,
                decoration: isMatched ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── Jawaban Benar/Salah ──

  Widget _buildAnswerButtons() {
    return Row(
      children: [
        Expanded(child: _buildAnswerButton(isBenar: true)),
        const SizedBox(width: 16),
        Expanded(child: _buildAnswerButton(isBenar: false)),
      ],
    );
  }

  Widget _buildAnswerButton({required bool isBenar}) {
    final label = isBenar ? 'Benar' : 'Salah';
    final iconData = isBenar ? Icons.check_rounded : Icons.close_rounded;
    final iconBgColor = isBenar ? primaryContainer : surfaceVariant;
    final iconColor = isBenar ? Colors.white : onSurfaceVariant;

    return GestureDetector(
      onTap: () => controller.answerQuestion(isBenar),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
              ),
              child: Icon(iconData, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Jawaban Pilihan Ganda ──

  Widget _buildMultipleChoiceOptions() {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question == null || question.opsi == null) {
        return const SizedBox.shrink();
      }

      return Column(
        children: List.generate(question.opsi!.length, (index) {
          final label = String.fromCharCode(65 + index); // A, B, C, D
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => controller.answerMultipleChoice(index),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: surfaceVariant,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        question.opsi![index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildFeedbackCard() {
    return Obx(() {
      final isCorrect = controller.answerStatus.value == AnswerStatus.correct;
      final bgColor =
          isCorrect ? const Color(0xFFE2E9E6) : const Color(0xFFFCE8E8);
      final title = isCorrect ? 'Tepat sekali!' : 'Kurang Tepat';
      final iconBg =
          isCorrect ? primaryContainer : const Color(0xFFB3261E);
      final iconData =
          isCorrect ? Icons.emoji_events_rounded : Icons.info_rounded;

      // Untuk pilihan ganda, tampilkan jawaban benar
      final question = controller.currentQuestion;
      String? correctAnswerText;
      if (!isCorrect &&
          question != null &&
          question.tipe == 'pilihan_ganda' &&
          question.opsi != null &&
          question.jawabanBenarIndex != null) {
        correctAnswerText =
            'Jawaban benar: ${String.fromCharCode(65 + question.jawabanBenarIndex!)}. ${question.opsi![question.jawabanBenarIndex!]}';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            if (correctAnswerText != null) ...[
              const SizedBox(height: 8),
              Text(
                correctAnswerText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB3261E),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              controller.feedbackMessage.value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.6,
                color: onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              child: ElevatedButton(
                onPressed: controller.nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lanjut',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFooterInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: primaryContainer,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL PELAJAR',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Al-Mubtadi',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'BAB TERAKHIR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: secondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                controller.data.judul ?? 'Materi',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  RESULT SCREEN
  // ══════════════════════════════════════════════════════════════

  Widget _buildResultScreen() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildScoreCard(),
                const SizedBox(height: 24),
                _buildXpEarned(),
                const SizedBox(height: 16),
                _buildResultMessage(),
                const SizedBox(height: 16),
                // Achievement unlocked
                Obx(() {
                  if (controller.newAchievements.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _buildNewAchievements();
                }),
                const SizedBox(height: 32),
                _buildResultActions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    return Obx(() {
      final score = controller.score.value;
      final total = controller.totalQuestions;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: primaryContainer,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: primaryContainer.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'SKOR AKHIR',
              style: GoogleFonts.plusJakartaSans(
                color: onPrimaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$score/$total',
              style: GoogleFonts.manrope(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controller.resultLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildXpEarned() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            '+${controller.earnedXp} XP didapatkan!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAchievements() {
    return Column(
      children: controller.newAchievements.map((achievement) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: secondaryContainer.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                achievement['icon'] as String? ?? '🏆',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎉 Achievement Baru!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      achievement['name'] as String? ?? '',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: onBackground,
                      ),
                    ),
                    Text(
                      achievement['desc'] as String? ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResultMessage() {
    return Obx(() {
      final pct = (controller.score.value / controller.totalQuestions) * 100;
      String msg = '';
      if (pct == 100) {
        msg =
            'Sempurna! Kamu telah menguasai materi ini dengan sangat baik. Teruskan semangat belajarmu!';
      } else if (pct >= 66) {
        msg =
            'Bagus! Kamu sudah memahami sebagian besar materi. Ulangi lagi untuk hasil yang lebih sempurna.';
      } else if (pct >= 33) {
        msg =
            'Terus berlatih! Baca kembali penjelasan materi dan coba lagi untuk meningkatkan skor.';
      } else {
        msg =
            'Jangan menyerah! Pelajari kembali teks inti dan penjelasannya, lalu coba ulangi latihan ini.';
      }

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 1.6,
            color: onSurfaceVariant,
          ),
        ),
      );
    });
  }

  Widget _buildResultActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.replay_rounded, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Ulangi Latihan',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              final score = controller.score.value;
              final total = controller.totalQuestions;
              final bab = controller.data.judul ?? '';
              Share.share(
                '🌟 Saya mendapat skor $score/$total di Bab "$bab" pada aplikasi Nahwu Master! Ayo belajar ilmu Nahwu bersama! 📚',
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: secondary,
              side: const BorderSide(color: secondaryContainer, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Bagikan Skor',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(color: surfaceVariant, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Kembali ke Materi',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
