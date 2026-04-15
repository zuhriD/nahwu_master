import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

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
    final bab = controller.bab;
    return Scaffold(
      backgroundColor: bgBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMatanCard(),
                    const SizedBox(height: 24),
                    if (bab.teksInti?.terjemahan != null) ...[
                      _buildTranslationSection(),
                      const SizedBox(height: 32),
                    ],
                    if (bab.teksInti?.penjelasan != null) ...[
                      _buildExplanationSection(),
                      const SizedBox(height: 32),
                    ],
                    _buildFlashcardButton(),
                    const SizedBox(height: 24),
                    _buildProgressVisualizer(),
                  ]),
                ),
              ),
            ],
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: onBackground.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgBackground.withValues(alpha: 0.8),
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Get.back(),
                    hoverColor: surfaceVariant,
                    highlightColor: primaryContainer,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, right: 16),
                      child: Icon(Icons.arrow_back_rounded, color: primary),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BAB ${controller.bab.id ?? ""}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: secondary,
                    ),
                  ),
                  Text(
                    controller.bab.judul ?? 'Detail Materi',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 18,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Bookmark button — now functional
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: controller.toggleBookmark,
                    hoverColor: surfaceVariant,
                    highlightColor: primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        controller.isBookmarked.value
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: controller.isBookmarked.value
                            ? secondary
                            : primary,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMatanCard() {
    final teksInti = controller.bab.teksInti;
    if (teksInti == null || teksInti.arab == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryContainer.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -40,
            child: Icon(
              Icons.format_quote_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'MATAN AL-JURUMIYAH',
                      style: GoogleFonts.plusJakartaSans(
                        color: onBackground,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  // TTS Button
                  Obx(() => Row(
                        children: [
                          GestureDetector(
                            onTap: controller.toggleSpeed,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                controller.speedLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                controller.speakArabic(teksInti.arab!),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.isSpeaking.value
                                    ? secondary
                                    : Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                controller.isSpeaking.value
                                    ? Icons.stop_rounded
                                    : Icons.volume_up_rounded,
                                color: controller.isSpeaking.value
                                    ? onBackground
                                    : onPrimaryContainer,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                teksInti.arab ?? "",
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 36,
                  height: 2.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (teksInti.latin != null) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1))),
                  ),
                  child: Text(
                    '"${teksInti.latin!}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: onPrimaryContainer,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationSection() {
    final teksInti = controller.bab.teksInti;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: secondaryContainer.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: const Border(
          left: BorderSide(color: secondary, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TERJEMAHAN',
            style: GoogleFonts.plusJakartaSans(
              color: secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${teksInti!.terjemahan!}"',
            style: GoogleFonts.plusJakartaSans(
              color: onBackground,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationSection() {
    final penjelasan = controller.bab.teksInti!.penjelasan!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 2,
              color: secondary,
            ),
            const SizedBox(width: 12),
            Text(
              'Syarah (Penjelasan)',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (penjelasan.pengantar != null) ...[
          Text(
            penjelasan.pengantar!,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant,
              fontSize: 15,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (penjelasan.poinPoin != null)
          ...penjelasan.poinPoin!.map((poin) => _buildPoinCard(poin)),
        if (penjelasan.contoh != null) ...[
          const SizedBox(height: 12),
          _buildContohCard(penjelasan.contoh!),
        ],
      ],
    );
  }

  Widget _buildPoinCard(dynamic poin) {
    IconData iconData = Icons.label_important_rounded;
    if (poin.icon == 'record_voice_over') iconData = Icons.record_voice_over_rounded;
    if (poin.icon == 'layers') iconData = Icons.layers_rounded;
    if (poin.icon == 'check_circle') iconData = Icons.check_circle_rounded;
    if (poin.icon == 'edit_note') iconData = Icons.edit_note_rounded;
    if (poin.icon == 'pentagon') iconData = Icons.pentagon_rounded;
    if (poin.icon == 'bolt') iconData = Icons.bolt_rounded;
    if (poin.icon == 'link') iconData = Icons.link_rounded;
    if (poin.icon == 'keyboard_arrow_down') iconData = Icons.keyboard_arrow_down_rounded;
    if (poin.icon == 'done_all') iconData = Icons.done_all_rounded;
    if (poin.icon == 'text_format') iconData = Icons.text_format_rounded;
    if (poin.icon == 'verified') iconData = Icons.verified_rounded;
    if (poin.icon == 'fast_forward') iconData = Icons.fast_forward_rounded;
    if (poin.icon == 'woman_2') iconData = Icons.woman_2_rounded;
    if (poin.icon == 'swap_horiz') iconData = Icons.swap_horiz_rounded;
    if (poin.icon == 'lock') iconData = Icons.lock_rounded;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData, color: primaryContainer, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  poin.judul ?? '',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            poin.teks ?? '',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.6,
              color: onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContohCard(dynamic contoh) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_rounded, color: secondary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Contoh Kalimat',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
              // TTS untuk contoh
              if (contoh.arab != null)
                GestureDetector(
                  onTap: () => controller.speakArabic(contoh.arab!),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.volume_up_rounded,
                        color: primary, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    contoh.arti ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  contoh.arab ?? '',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          if (contoh.catatan != null) ...[
            const SizedBox(height: 16),
            Text(
              contoh.catatan!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: onSurfaceVariant.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Tombol untuk masuk ke mode Flashcard
  Widget _buildFlashcardButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.FLASHCARD, arguments: controller.bab),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: secondaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: secondaryContainer, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🃏', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mode Flashcard',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hafal istilah-istilah penting dengan kartu bolak-balik',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressVisualizer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS MATERI',
                style: GoogleFonts.plusJakartaSans(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '15% Selesai',
                style: GoogleFonts.plusJakartaSans(
                  color: secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Expanded(flex: 85, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final latsLength = controller.bab.latihan?.length ?? 0;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgBackground.withValues(alpha: 0.8),
          border: const Border(
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        child: ElevatedButton(
          onPressed: controller.mulaiLatihan,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: primary.withValues(alpha: 0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mulai Latihan ($latsLength Soal)',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
