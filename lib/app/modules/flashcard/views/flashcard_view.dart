import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/flashcard_controller.dart';

class FlashcardView extends GetView<FlashcardController> {
  const FlashcardView({super.key});

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
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),
            Expanded(child: _buildCardArea()),
            _buildControls(),
            const SizedBox(height: 24),
          ],
        ),
      ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FLASHCARD',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: secondary,
                    ),
                  ),
                  Text(
                    controller.isBab
                        ? 'Bab ${controller.data.id}: ${controller.data.judul ?? ""}'
                        : 'Sub Bab ${controller.data.id}: ${controller.data.judul ?? ""}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${controller.masteredCount.value}/${controller.totalCards}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: secondary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Obx(() {
      final progress = controller.totalCards > 0
          ? (controller.currentIndex.value + 1) / controller.totalCards
          : 0.0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kartu ${controller.currentIndex.value + 1} dari ${controller.totalCards}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: onSurfaceVariant,
                  ),
                ),
                Text(
                  '${controller.masteredCount.value} dikuasai',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCardArea() {
    return Obx(() {
      if (controller.cards.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada flashcard untuk bab ini',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: onSurfaceVariant,
            ),
          ),
        );
      }

      final card = controller.cards[controller.currentIndex.value];
      final isFlipped = controller.isFlipped.value;

      return GestureDetector(
        onTap: controller.flipCard,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! > 300) {
            // Swipe right — mastered
            controller.markAsMastered();
          } else if (details.primaryVelocity! < -300) {
            // Swipe left — not mastered
            controller.markAsNotMastered();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: isFlipped ? 1 : 0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              final isFront = value < 0.5;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value * pi),
                child: isFront
                    ? _buildFrontCard(card)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _buildBackCard(card),
                      ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildFrontCard(FlashcardData card) {
    final bool isArabic = card.type == 'matan' || card.type == 'contoh';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryContainer.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              card.type == 'matan'
                  ? 'MATAN'
                  : card.type == 'contoh'
                      ? 'CONTOH'
                      : 'ISTILAH',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: onBackground,
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (isArabic)
            Text(
              card.front,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontSize: 32,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Text(
              card.front,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          if (card.latin != null) ...[
            const SizedBox(height: 16),
            Text(
              card.latin!,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: onPrimaryContainer,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isArabic)
                _buildCardAction(
                  icon: Icons.volume_up_rounded,
                  onTap: () => controller.speak(card.front),
                ),
              const SizedBox(width: 16),
              _buildCardAction(
                icon: Icons.flip_rounded,
                label: 'Balik',
                onTap: controller.flipCard,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.isCurrentMastered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '✅ Sudah dikuasai',
                style: GoogleFonts.plusJakartaSans(
                  color: onPrimaryContainer,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackCard(FlashcardData card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'JAWABAN',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: secondary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            card.back,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: onBackground,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 32),
          _buildCardAction(
            icon: Icons.flip_rounded,
            label: 'Balik',
            onTap: controller.flipCard,
            dark: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCardAction({
    required IconData icon,
    String? label,
    required VoidCallback onTap,
    bool dark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: dark
              ? surfaceContainerLow
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: dark ? primary : Colors.white,
            ),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: dark ? primary : Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Swipe hint
          Text(
            '← Geser kiri: Belum hafal  •  Geser kanan: Sudah hafal →',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Belum hafal button
              Expanded(
                child: GestureDetector(
                  onTap: controller.markAsNotMastered,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE8E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close_rounded,
                            color: Color(0xFFB3261E), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Belum',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFB3261E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Sudah hafal button
              Expanded(
                child: GestureDetector(
                  onTap: controller.markAsMastered,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E9E6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded,
                            color: primaryContainer, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Hafal',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
