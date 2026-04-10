import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
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
        const SizedBox(height: 12),
        _buildProgressSection(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                _buildQuestionCard(),
                const SizedBox(height: 16),
                Obx(() => controller.showFeedback.value
                    ? _buildFeedbackCard()
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                Obx(() => controller.showFeedback.value
                    ? _buildNextButton()
                    : _buildAnswerButtons()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Color(0xFF1A237E)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.bab.judul ?? 'Latihan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A237E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Latihan Soal',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Score badge
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A237E).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  '${controller.score.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ─── PROGRESS SECTION ────────────────────────────────────────

  Widget _buildProgressSection() {
    return Obx(() {
      final current = controller.currentQuestionIndex.value + 1;
      final total = controller.totalQuestions;
      final progress = current / total;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pertanyaan $current dari $total',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3949AB)),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── QUESTION CARD ───────────────────────────────────────────

  Widget _buildQuestionCard() {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question == null) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon soal
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('❓', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 16),
            // Label pertanyaan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'P E R T A N Y A A N',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question.pertanyaan ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
                height: 1.65,
              ),
            ),
            const SizedBox(height: 8),
            // Hint
            Text(
              'Pilih jawaban yang tepat ↓',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── ANSWER BUTTONS ──────────────────────────────────────────

  Widget _buildAnswerButtons() {
    return Row(
      children: [
        Expanded(child: _buildAnswerButton(isBenar: true)),
        const SizedBox(width: 12),
        Expanded(child: _buildAnswerButton(isBenar: false)),
      ],
    );
  }

  Widget _buildAnswerButton({required bool isBenar}) {
    final color = isBenar ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C);
    final icon = isBenar ? '✅' : '❌';
    final label = isBenar ? 'BENAR' : 'SALAH';
    final lightColor = isBenar ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return GestureDetector(
      onTap: () => controller.answerQuestion(isBenar),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FEEDBACK CARD ───────────────────────────────────────────

  Widget _buildFeedbackCard() {
    return Obx(() {
      final isCorrect = controller.answerStatus.value == AnswerStatus.correct;
      final color = isCorrect ? const Color(0xFF1B5E20) : const Color(0xFFC62828);
      final bgColor = isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
      final emoji = isCorrect ? '🎉' : '💭';
      final title = isCorrect ? 'Jawaban Benar!' : 'Jawaban Kurang Tepat';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.feedbackMessage.value,
                style: TextStyle(
                  color: color.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── NEXT BUTTON ─────────────────────────────────────────────

  Widget _buildNextButton() {
    return Obx(() {
      final isLast = controller.currentQuestionIndex.value == controller.totalQuestions - 1;
      return Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: controller.nextQuestion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  isLast ? 'Lihat Hasil' : 'Soal Selanjutnya',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ══════════════════════════════════════════════════════════════
  //  RESULT SCREEN
  // ══════════════════════════════════════════════════════════════

  Widget _buildResultScreen() {
    return Column(
      children: [
        _buildResultHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildScoreCard(),
                const SizedBox(height: 16),
                _buildResultStats(),
                const SizedBox(height: 16),
                _buildResultMessage(),
                const SizedBox(height: 24),
                _buildResultActions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            controller.bab.judul ?? '',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text(
            '🏆 Hasil Latihan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Obx(() {
      final score = controller.score.value;
      final total = controller.totalQuestions;
      final pct = ((score / total) * 100).toInt();
      final color = controller.resultColor;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Circular score
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: score / total,
                    strokeWidth: 10,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/ $total',
                      style: TextStyle(
                        fontSize: 16,
                        color: color.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              controller.resultLabel,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$pct% Jawaban Benar',
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildResultStats() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Benar',
            value: '${controller.score.value}',
            emoji: '✅',
            color: const Color(0xFF1B5E20),
            bgColor: const Color(0xFFE8F5E9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Salah',
            value: '${controller.totalQuestions - controller.score.value}',
            emoji: '❌',
            color: const Color(0xFFB71C1C),
            bgColor: const Color(0xFFFFEBEE),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Total',
            value: '${controller.totalQuestions}',
            emoji: '📝',
            color: const Color(0xFF1A237E),
            bgColor: const Color(0xFFF0F4FF),
          ),
        ),
      ],
    ));
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String emoji,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultMessage() {
    return Obx(() {
      final pct = (controller.score.value / controller.totalQuestions) * 100;
      String msg;
      String emoji;
      if (pct == 100) {
        emoji = '🌟';
        msg = 'Sempurna! Kamu telah menguasai materi ini dengan sangat baik. Teruskan semangat belajarmu!';
      } else if (pct >= 66) {
        emoji = '💪';
        msg = 'Bagus! Kamu sudah memahami sebagian besar materi. Ulangi lagi untuk hasil yang lebih sempurna.';
      } else if (pct >= 33) {
        emoji = '📚';
        msg = 'Terus berlatih! Baca kembali penjelasan materi dan coba lagi untuk meningkatkan skor.';
      } else {
        emoji = '🔄';
        msg = 'Jangan menyerah! Pelajari kembali teks inti dan penjelasannya, lalu coba ulangi latihan ini.';
      }

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFCC02).withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: Color(0xFF5D4037),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildResultActions() {
    return Column(
      children: [
        // Ulangi
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A237E).withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: controller.restartQuiz,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Ulangi Latihan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Kembali
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text(
              'Kembali ke Materi',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A237E),
              side: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ],
    );
  }
}
