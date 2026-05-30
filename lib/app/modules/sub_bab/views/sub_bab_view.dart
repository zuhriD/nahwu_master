import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/diagram_widget.dart';
import '../../../widgets/konsep_card_widget.dart';
import '../../../widgets/tabel_widget.dart';
import '../controllers/sub_bab_controller.dart';

class SubBabView extends GetView<SubBabController> {
  const SubBabView({super.key});

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
    final subBab = controller.subBab;
    return Scaffold(
      backgroundColor: bgBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 24, bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMatanCard(),
                    const SizedBox(height: 24),
                    if (subBab.teksInti?.terjemahan != null) ...[
                      _buildTranslationSection(),
                      const SizedBox(height: 32),
                    ],
                    if (subBab.materialAudioPath != null) ...[
                      _buildMaterialAudioButton(),
                      const SizedBox(height: 24),
                    ],
                    if (controller.hasYoutubeVideo) ...[
                      _buildYoutubeSection(),
                      const SizedBox(height: 32),
                    ],
                    if (subBab.mindMapImagePath != null) ...[
                      _buildMindMapSection(),
                      const SizedBox(height: 32),
                    ],

                    if (subBab.teksInti?.penjelasan != null) ...[
                      _buildExplanationSection(),
                      const SizedBox(height: 32),
                    ],
                    // === ADVANCED UI: Diagram ===
                    if (subBab.hasDiagram) ...[
                      _buildSectionHeader('Diagram'),
                      const SizedBox(height: 16),
                      DiagramWidget(diagram: subBab.diagram!),
                      const SizedBox(height: 32),
                    ],
                    // === ADVANCED UI: Konsep Card ===
                    if (subBab.hasKonsep) ...[
                      _buildSectionHeader('Konsep Utama'),
                      const SizedBox(height: 16),
                      KonsepCardWidget(
                        konsep: subBab.allKonsep,
                        layout: "horizontal",
                        primaryColor: primary,
                      ),
                      const SizedBox(height: 32),
                    ],
                    // === ADVANCED UI: Tabel ===
                    if (subBab.hasTabel) ...[
                      _buildSectionHeader('Ringkasan Tabel'),
                      const SizedBox(height: 16),
                      TabelWidget(tabel: subBab.tabel!),
                      const SizedBox(height: 32),
                    ],
                    ..._buildV2ContentSections(),
                    if (subBab.lagu != null) ...[
                      _buildSongButton(),
                      const SizedBox(height: 24),
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

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 2,
          color: secondary,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
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
                    'SUB BAB ${controller.subBab.id ?? ""}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: secondary,
                    ),
                  ),
                  Text(
                    controller.subBab.judul ?? 'Detail Sub Bab',
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
                        color:
                            controller.isBookmarked.value ? secondary : primary,
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
    final teksIntiList = controller.subBab.teksIntiList;
    if (teksIntiList.isEmpty) return const SizedBox.shrink();

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          if (teksIntiList.first.arab != null)
                            GestureDetector(
                              onTap: () => controller
                                  .speakArabic(teksIntiList.first.arab!),
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
              ...teksIntiList.asMap().entries.map((entry) {
                final teksInti = entry.value;
                return Padding(
                  padding: EdgeInsets.only(top: entry.key == 0 ? 0 : 28),
                  child: Column(
                    children: [
                      if (teksInti.arab != null)
                        Text(
                          teksInti.arab!,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            color: Colors.white,
                            fontSize: 34,
                            height: 2.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (teksInti.latin != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
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
                      if (teksInti.sumber != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          teksInti.sumber!,
                          style: GoogleFonts.plusJakartaSans(
                            color: onPrimaryContainer.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialAudioButton() {
    return Obx(() => GestureDetector(
          onTap: controller.toggleMaterialAudio,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: surfaceVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    controller.isAudioLoading.value
                        ? Icons.more_horiz_rounded
                        : controller.isAudioPlaying.value
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.subBab.materialAudioTitle ?? 'Audio Materi',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      Text(
                        controller.subBab.materialAudioPath!
                            .replaceFirst('assets/audio/', ''),
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
          ),
        ));
  }

  Widget _buildYoutubeSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.ensureYoutubeInitialized();
    });

    return Obx(() {
      if (controller.youtubeError.value.isNotEmpty) {
        return _buildVideoFallback(controller.youtubeError.value);
      }

      final ytController = controller.ytController;
      if (!controller.isYoutubeReady.value || ytController == null) {
        return _buildVideoFallback('Menyiapkan video materi...');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Video Materi'),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: onBackground.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: YoutubePlayer(
                controller: ytController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: secondaryContainer,
                progressColors: const ProgressBarColors(
                  playedColor: secondaryContainer,
                  handleColor: secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFFFF0000),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.subBab.videoTitle ?? 'Video Penjelasan Materi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVideoFallback(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: surfaceVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_display_rounded, color: primaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapSection() {
    final imagePath = controller.subBab.mindMapImagePath!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Mind Mapping'),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: onBackground.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: GestureDetector(
                  onTap: () => _showMindMapDialog(
                    context: Get.context!,
                    imagePath: imagePath,
                    title: controller.subBab.mindMapTitle ??
                        controller.subBab.mindMapAlt ??
                        'Mind Mapping Materi',
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildMissingMindMap(imagePath);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree_rounded,
                        color: primaryContainer, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.subBab.mindMapTitle ??
                            controller.subBab.mindMapAlt ??
                            'Mind Mapping Materi',
                        style: GoogleFonts.plusJakartaSans(
                          color: onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissingMindMap(String imagePath) {
    return Container(
      color: surfaceContainerLow,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported_rounded,
              color: onSurfaceVariant, size: 44),
          const SizedBox(height: 12),
          Text(
            'Gambar mind mapping belum ditemukan',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            imagePath,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMindMapDialog({
    required BuildContext context,
    required String imagePath,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 14, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 5,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildMissingMindMap(imagePath),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranslationSection() {
    final teksInti = controller.subBab.teksInti;
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
    final penjelasan = controller.subBab.teksInti!.penjelasan!;
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
        // if (penjelasan.contoh != null) ...[
        //   const SizedBox(height: 12),
        //   _buildContohCard(penjelasan.contoh!),
        // ],
      ],
    );
  }

  Widget _buildPoinCard(dynamic poin) {
    IconData iconData = Icons.label_important_rounded;
    if (poin.icon == 'record_voice_over') {
      iconData = Icons.record_voice_over_rounded;
    }
    if (poin.icon == 'layers') iconData = Icons.layers_rounded;
    if (poin.icon == 'check_circle') iconData = Icons.check_circle_rounded;
    if (poin.icon == 'edit_note') iconData = Icons.edit_note_rounded;
    if (poin.icon == 'pentagon') iconData = Icons.pentagon_rounded;
    if (poin.icon == 'bolt') iconData = Icons.bolt_rounded;
    if (poin.icon == 'link') iconData = Icons.link_rounded;
    if (poin.icon == 'keyboard_arrow_down') {
      iconData = Icons.keyboard_arrow_down_rounded;
    }
    if (poin.icon == 'done_all') iconData = Icons.done_all_rounded;
    if (poin.icon == 'text_format') iconData = Icons.text_format_rounded;
    if (poin.icon == 'verified') iconData = Icons.verified_rounded;
    if (poin.icon == 'fast_forward') iconData = Icons.fast_forward_rounded;
    if (poin.icon == 'woman_2') iconData = Icons.woman_2_rounded;
    if (poin.icon == 'swap_horiz') iconData = Icons.swap_horiz_rounded;
    if (poin.icon == 'lock') iconData = Icons.lock_rounded;
    if (poin.icon == 'cancel') iconData = Icons.cancel_rounded;
    if (poin.icon == 'person') iconData = Icons.person_rounded;
    if (poin.icon == 'schedule') iconData = Icons.schedule_rounded;
    if (poin.icon == 'woman') iconData = Icons.woman_rounded;

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
                  const Icon(Icons.lightbulb_rounded,
                      color: secondary, size: 20),
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

  List<Widget> _buildV2ContentSections() {
    final raw = controller.subBab.rawJson;
    final sections = <Widget>[];

    final keterangan = raw['keterangan'];
    if (keterangan is String && keterangan.trim().isNotEmpty) {
      sections.add(_buildSectionHeader('Keterangan'));
      sections.add(const SizedBox(height: 16));
      sections.add(_buildTextPanel(keterangan));
      sections.add(const SizedBox(height: 32));
    } else if (keterangan is List && keterangan.isNotEmpty) {
      sections.add(_buildSectionHeader('Keterangan'));
      sections.add(const SizedBox(height: 16));
      sections.add(_buildBulletList(keterangan));
      sections.add(const SizedBox(height: 32));
    }

    final contoh = raw['contoh'];
    if (contoh is List && contoh.isNotEmpty) {
      sections.add(_buildSectionHeader('Contoh'));
      sections.add(const SizedBox(height: 16));
      sections.add(_buildContohList(contoh));
      sections.add(const SizedBox(height: 32));
    }

    for (final key in [
      'unsur',
      'jenis_kata',
      'tanda',
      'penjelasan_unsur',
      'contoh_visual',
    ]) {
      final value = raw[key];
      if (value is List && value.isNotEmpty) {
        sections.add(_buildSectionHeader(_labelFromKey(key)));
        sections.add(const SizedBox(height: 16));
        sections.add(key == 'contoh_visual'
            ? _buildVisualExampleCardList(value)
            : _buildGenericCardList(value));
        sections.add(const SizedBox(height: 32));
      }
    }

    for (final entry in raw.entries) {
      if (!entry.key.startsWith('tabel')) continue;
      final value = entry.value;
      if (value is Map<String, dynamic> &&
          value['headers'] is List &&
          value['rows'] is List) {
        final headers =
            (value['headers'] as List).map((e) => e.toString()).toList();
        final hasSourceColumn = (value['rows'] as List).any(
          (row) =>
              row is Map &&
              _firstString(row.cast<String, dynamic>(), ['sumber']) != null,
        );
        final tableHeaders = hasSourceColumn ? [...headers, 'sumber'] : headers;
        final rows = (value['rows'] as List).map<List<String>>((row) {
          if (row is Map) {
            final rowMap = row.cast<String, dynamic>();
            return tableHeaders
                .map((header) => rowMap[header]?.toString() ?? '')
                .toList();
          }
          if (row is List) {
            final values = row.map((e) => e.toString()).toList();
            return hasSourceColumn ? [...values, ''] : values;
          }
          return [row.toString()];
        }).toList();
        sections.add(_buildSectionHeader(_labelFromKey(entry.key)));
        sections.add(const SizedBox(height: 16));
        sections.add(SimpleDataTable(
          title: '',
          headers: tableHeaders.map(_labelFromKey).toList(),
          rows: rows,
          headerBgColor: secondaryContainer.withValues(alpha: 0.7),
          headerTextColor: primary,
        ));
        sections.add(const SizedBox(height: 32));
      }
    }

    return sections;
  }

  Widget _buildBulletList(List<dynamic> items) {
    final lines = items
        .map((entry) => entry?.toString().trim() ?? '')
        .where((entry) => entry.isNotEmpty)
        .toList();
    if (lines.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        line,
                        style: GoogleFonts.plusJakartaSans(
                          color: onSurfaceVariant,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildContohList(List<dynamic> items) {
    final entries = items.whereType<Map>().map((item) {
      return item.cast<String, dynamic>();
    }).toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      children: entries
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildReferenceExampleCard(item),
            ),
          )
          .toList(),
    );
  }

  Widget _buildReferenceExampleCard(Map<String, dynamic> item) {
    final arab = _firstString(item, ['arab']);
    final arabSegments = item['arab_segments'];
    final reference = _firstString(item, ['rujukan', 'keterangan']);
    final meaning = _firstString(item, ['arti', 'terjemahan', 'makna']);
    final source = _firstString(item, ['sumber']);
    final highlight = item['tanda_berwarna'];
    final highlightDescription = highlight is Map
        ? _firstString(highlight.cast<String, dynamic>(), ['keterangan'])
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reference != null) ...[
            Text(
              reference,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: secondary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (_hasArabicSegments(arabSegments)) ...[
            _buildArabicSegmentsText(arabSegments, fontSize: 24),
          ] else if (arab != null) ...[
            Text(
              arab,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 1.7,
                color: primary,
              ),
            ),
          ],
          if (highlightDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              highlightDescription,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                height: 1.5,
                color: onSurfaceVariant.withValues(alpha: 0.88),
              ),
            ),
          ],
          if (meaning != null) ...[
            const SizedBox(height: 10),
            Text(
              meaning,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.6,
                color: onSurfaceVariant,
              ),
            ),
          ],
          if (source != null) ...[
            const SizedBox(height: 12),
            _buildSourceLabel(source),
          ],
          ..._buildAdditionalSourceLabels(item, ['sumber_bukan_contoh']),
        ],
      ),
    );
  }

  Widget _buildTextPanel(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: onSurfaceVariant,
          fontSize: 14,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildGenericCardList(List<dynamic> items) {
    return Column(
      children: items
          .whereType<Map<String, dynamic>>()
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildGenericCard(item),
              ))
          .toList(),
    );
  }

  Widget _buildGenericCard(Map<String, dynamic> item) {
    final title = _firstString(item, ['nama', 'judul', 'tanda', 'irab']) ??
        _labelFromKey(item['id']?.toString() ?? 'Materi');
    final arab = _firstString(item, ['arab']);
    final description =
        _firstString(item, ['definisi', 'keterangan', 'arti', 'ringkasan']);
    final fungsi = item['fungsi'];
    final examples = item['contoh'];
    final verseExamples = item['contoh_ayat'];
    final exampleMeanings = item['contoh_arti'];
    final translatedExamples = item['contoh_terjemahan'];
    final source = _firstString(item, ['sumber']);
    final hasVisualFields = item.containsKey('contoh_kalimat') ||
        item.containsKey('kalimat') ||
        item.containsKey('keterangan') ||
        item.containsKey('image_path');

    if (hasVisualFields) {
      return _buildVisualExampleCard(item);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories_rounded,
                    color: primaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          if (arab != null) ...[
            const SizedBox(height: 12),
            Text(
              arab,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 1.7,
                color: primary,
              ),
            ),
          ],
          if (description != null) ...[
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.6,
                color: onSurfaceVariant,
              ),
            ),
          ],
          if (fungsi != null) ...[
            const SizedBox(height: 12),
            _buildFieldBlock(
              label: 'Fungsi',
              value: fungsi,
              accent: secondaryContainer,
            ),
          ],
          ..._buildStringChips(item, ['ciri', 'syarat']),
          if (examples != null) ...[
            const SizedBox(height: 12),
            if (_hasTranslatedExamples(translatedExamples))
              _buildTranslatedExamples(translatedExamples)
            else if (_toStringList(exampleMeanings).isNotEmpty)
              _buildPairedExamples(examples, exampleMeanings)
            else
              _buildExamples(examples),
          ],
          if (verseExamples != null) ...[
            const SizedBox(height: 12),
            _buildExampleBlock(
              label: 'Contoh Ayat',
              examples: verseExamples,
            ),
          ],
          if (_toStringList(item['bukan_contoh']).isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildMarkedTextList(
              label: 'Bukan Contoh',
              value: item['bukan_contoh'],
              icon: Icons.close_rounded,
              iconColor: const Color(0xFFB3261E),
            ),
          ],
          if (source != null) ...[
            const SizedBox(height: 12),
            _buildSourceLabel(source),
          ],
          ..._buildAdditionalSourceLabels(item, ['sumber_contoh']),
        ],
      ),
    );
  }

  Widget _buildVisualExampleCardList(List<dynamic> items) {
    return Column(
      children: items
          .whereType<Map<String, dynamic>>()
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildVisualExampleCard(item),
              ))
          .toList(),
    );
  }

  Widget _buildVisualExampleCard(Map<String, dynamic> item) {
    final title = _firstString(item, ['irab', 'nama', 'judul']) ?? 'Contoh';
    final colorLabel = _firstString(item, ['color']) ?? '';
    final contohKalimat = _firstString(item, ['contoh_kalimat']);
    final arab = _firstString(item, ['arab']);
    final keterangan = _firstString(item, ['keterangan']);
    final kalimat = _firstString(item, ['kalimat']);
    final arti = _firstString(item, ['arti']);
    final source = _firstString(item, ['sumber']);

    String? colorText;
    switch (colorLabel.toLowerCase()) {
      case 'blue':
        colorText = 'Biru';
        break;
      case 'red':
        colorText = 'Merah';
        break;
      case 'green':
        colorText = 'Hijau';
        break;
      case 'yellow':
        colorText = 'Kuning';
        break;
      default:
        colorText = colorLabel.isNotEmpty ? colorLabel : null;
    }

    final cardFields = <Widget>[
      if (contohKalimat != null)
        _buildVisualField('Contoh Kalimat', contohKalimat),
      if (arab != null) ...[
        const SizedBox(height: 12),
        _buildVisualArabicPanel('Arab', arab),
      ],
      if (keterangan != null) ...[
        const SizedBox(height: 12),
        _buildVisualField('Keterangan', keterangan),
      ],
      if (kalimat != null) ...[
        const SizedBox(height: 12),
        _buildVisualField('Kalimat', kalimat),
      ],
      if (arti != null) ...[
        const SizedBox(height: 12),
        _buildVisualField('Arti', arti),
      ],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories_rounded,
                    color: primaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
              if (colorText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    colorText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: secondary,
                    ),
                  ),
                ),
            ],
          ),
          if (cardFields.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...cardFields,
          ],
          if (source != null) ...[
            const SizedBox(height: 12),
            _buildSourceLabel(source),
          ],
          ..._buildNestedSourceLabels(item, ['penjelasan_huruf_arab']),
        ],
      ),
    );
  }

  List<Widget> _buildNestedSourceLabels(
    Map<String, dynamic> item,
    List<String> keys,
  ) {
    final widgets = <Widget>[];
    for (final key in keys) {
      final value = item[key];
      final labels = _collectSourceLabels(value, [_labelFromKey(key)]);
      for (final label in labels) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(_buildSourceLabel(label));
      }
    }
    return widgets;
  }

  List<Widget> _buildAdditionalSourceLabels(
    Map<String, dynamic> item,
    List<String> keys,
  ) {
    final widgets = <Widget>[];
    for (final key in keys) {
      final source = _firstString(item, [key]);
      if (source == null) continue;
      widgets.add(const SizedBox(height: 8));
      widgets.add(_buildSourceLabel('${_labelFromKey(key)}: $source'));
    }
    return widgets;
  }

  List<String> _collectSourceLabels(dynamic value, List<String> path) {
    if (value is Map) {
      final item = value.cast<String, dynamic>();
      final labels = <String>[];
      final source = _firstString(item, ['sumber']);
      if (source != null) {
        labels.add('${path.join(' > ')}: $source');
      }
      for (final entry in item.entries) {
        if (entry.key == 'sumber') continue;
        if (entry.value is Map || entry.value is List) {
          labels.addAll(
            _collectSourceLabels(
                entry.value, [...path, _labelFromKey(entry.key)]),
          );
        }
      }
      return labels;
    }
    if (value is List) {
      final labels = <String>[];
      for (var index = 0; index < value.length; index++) {
        final item = value[index];
        final itemTitle = item is Map
            ? _firstString(item.cast<String, dynamic>(), [
                  'teks',
                  'nama',
                  'judul',
                  'arab',
                ]) ??
                '${index + 1}'
            : '${index + 1}';
        labels.addAll(_collectSourceLabels(item, [...path, itemTitle]));
      }
      return labels;
    }
    return const [];
  }

  Widget _buildSourceLabel(String source) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryContainer.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryContainer.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.source_rounded,
            size: 14,
            color: primaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sumber: $source',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualField(String label, String value) {
    return _buildFieldBlock(
      label: label,
      value: value,
      accent: surfaceContainerLow,
    );
  }

  Widget _buildVisualArabicPanel(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 24,
              height: 1.7,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldBlock({
    required String label,
    required dynamic value,
    required Color accent,
  }) {
    final entries = _toStringList(value);
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          if (entries.length == 1)
            Text(
              entries.first,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.6,
                color: onSurfaceVariant,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 7),
                            decoration: const BoxDecoration(
                              color: primaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                height: 1.6,
                                color: onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  List<String> _toStringList(dynamic value) {
    if (value == null) return const [];
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? const [] : [trimmed];
    }
    if (value is List) {
      return value
          .map((entry) {
            if (entry == null) return '';
            if (entry is Map) {
              return _firstString(entry.cast<String, dynamic>(), [
                    'nama',
                    'judul',
                    'tanda',
                    'arab',
                    'arti',
                    'keterangan',
                    'fungsi',
                  ]) ??
                  '';
            }
            return entry.toString();
          })
          .map((entry) => entry.trim())
          .where((entry) => entry.isNotEmpty)
          .toList();
    }
    final text = value.toString().trim();
    return text.isEmpty ? const [] : [text];
  }

  List<Widget> _buildStringChips(
    Map<String, dynamic> item,
    List<String> keys,
  ) {
    final widgets = <Widget>[];
    for (final key in keys) {
      final value = item[key];
      if (value is! List || value.isEmpty) continue;
      widgets.add(const SizedBox(height: 12));
      widgets.add(Wrap(
        spacing: 8,
        runSpacing: 8,
        children: value
            .map((entry) => Chip(
                  label: Text(
                    entry is Map
                        ? (entry['arab'] ??
                                entry['nama'] ??
                                entry['arti'] ??
                                '')
                            .toString()
                        : entry.toString(),
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  backgroundColor: surfaceContainerLow,
                  side: BorderSide(color: surfaceVariant),
                ))
            .toList(),
      ));
    }
    return widgets;
  }

  Widget _buildMarkedTextList({
    required String label,
    required dynamic value,
    required IconData icon,
    required Color iconColor,
  }) {
    final entries = _toStringList(value);
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusIcon(icon: icon, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry,
                      style: _containsArabic(entry)
                          ? GoogleFonts.amiri(
                              fontSize: 18,
                              height: 1.5,
                              color: primary,
                            )
                          : GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              height: 1.5,
                              color: onSurfaceVariant,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 15),
    );
  }

  Widget _buildExampleBlock({
    required String label,
    required dynamic examples,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        _buildExamples(examples),
      ],
    );
  }

  bool _hasArabicSegments(dynamic value) {
    return value is List && value.whereType<Map>().isNotEmpty;
  }

  Widget _buildArabicSegmentsText(
    dynamic value, {
    required double fontSize,
  }) {
    final segments = value is List
        ? value
            .whereType<Map>()
            .map((segment) => segment.cast<String, dynamic>())
            .toList()
        : const <Map<String, dynamic>>[];
    if (segments.isEmpty) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          children: segments.map((segment) {
            final text = _firstString(segment, ['teks']) ?? '';
            final color = _colorFromHex(segment['hex'] as String?);
            final isHighlighted = segment['is_tanda_huruf'] == true;
            final isBold = segment['bold'] == true || isHighlighted;

            return TextSpan(
              text: text,
              style: GoogleFonts.amiri(
                fontSize: fontSize,
                height: 1.7,
                color: color ?? primary,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color? _colorFromHex(String? hex) {
    if (hex == null || hex.trim().isEmpty) return null;
    final normalized = hex.replaceAll('#', '').trim();
    if (normalized.length != 6 && normalized.length != 8) return null;
    final value = int.tryParse(
      normalized.length == 6 ? 'FF$normalized' : normalized,
      radix: 16,
    );
    return value == null ? null : Color(value);
  }

  Widget _buildExamples(dynamic examples) {
    final list = examples is List ? examples : [examples];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map<Widget>((example) {
        if (example is Map) {
          final item = example.cast<String, dynamic>();
          final arab = _firstString(item, ['arab']);
          final arabSegments = item['arab_segments'];
          final meaning = _firstString(item, ['arti', 'terjemahan', 'makna']);
          final reference = _firstString(item, ['rujukan', 'keterangan']);
          final highlight = item['tanda_berwarna'];
          final highlightDescription = highlight is Map
              ? _firstString(highlight.cast<String, dynamic>(), ['keterangan'])
              : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStatusIcon(
                        icon: Icons.check_rounded,
                        color: primaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Contoh',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (reference != null) ...[
                    Text(
                      reference,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (_hasArabicSegments(arabSegments))
                    _buildArabicSegmentsText(arabSegments, fontSize: 20)
                  else if (arab != null)
                    Text(
                      arab,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        height: 1.5,
                        color: primary,
                      ),
                    ),
                  if (highlightDescription != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      highlightDescription,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        height: 1.5,
                        color: onSurfaceVariant.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                  if (meaning != null) ...[
                    if (arab != null || _hasArabicSegments(arabSegments))
                      const SizedBox(height: 6),
                    Text(
                      meaning,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.5,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        final text = example.toString();
        final isArabic = _containsArabic(text);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusIcon(
                  icon: Icons.check_rounded,
                  color: primaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? GoogleFonts.amiri(
                            fontSize: 20,
                            height: 1.5,
                            color: primary,
                          )
                        : GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 1.5,
                            color: onSurfaceVariant,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _containsArabic(String text) {
    return RegExp(r'[؀-ۿ]').hasMatch(text);
  }

  bool _hasTranslatedExamples(dynamic examples) {
    if (examples is! List) return false;
    return examples.whereType<Map>().any((example) {
      final item = example.cast<String, dynamic>();
      return _firstString(item, ['arab']) != null &&
          _firstString(item, ['terjemahan', 'arti', 'makna']) != null;
    });
  }

  Widget _buildTranslatedExamples(dynamic examples) {
    final items = examples is List
        ? examples
            .whereType<Map>()
            .map((example) => example.cast<String, dynamic>())
            .toList()
        : const <Map<String, dynamic>>[];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map<Widget>((item) {
        final arab = _firstString(item, ['arab']);
        final translation = _firstString(item, ['terjemahan', 'arti', 'makna']);
        if (arab == null && translation == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStatusIcon(
                      icon: Icons.check_rounded,
                      color: primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contoh',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (arab != null)
                  Text(
                    arab,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      height: 1.5,
                      color: primary,
                    ),
                  ),
                if (translation != null) ...[
                  if (arab != null) const SizedBox(height: 6),
                  Text(
                    translation,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPairedExamples(dynamic examples, dynamic meanings) {
    final exampleList = _toStringList(examples);
    final meaningList = _toStringList(meanings);
    if (exampleList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(exampleList.length, (index) {
        final example = exampleList[index];
        final meaning = index < meaningList.length ? meaningList[index] : null;
        final isArabic = _containsArabic(example);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == exampleList.length - 1 ? 0 : 8,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStatusIcon(
                      icon: Icons.check_rounded,
                      color: primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contoh',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  example,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: isArabic
                      ? GoogleFonts.amiri(
                          fontSize: 20,
                          height: 1.5,
                          color: primary,
                        )
                      : GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.5,
                          color: onSurfaceVariant,
                        ),
                ),
                if (meaning != null && meaning.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    meaning,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  String? _firstString(Map<String, dynamic> item, List<String> keys) {
    for (final key in keys) {
      final value = item[key];
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  String _labelFromKey(String key) {
    if (key == 'contoh_visual') return 'Contoh';
    final normalized = key
        .replaceAll('tabel_', '')
        .replaceAll('_', ' ')
        .replaceAll('irab', 'i’rab');
    return normalized
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Tombol untuk masuk ke mode Flashcard
  Widget _buildFlashcardButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.FLASHCARD, arguments: controller.subBab),
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

  /// Tombol untuk masuk ke mode Lagu Matan
  Widget _buildSongButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.LAGU_MATAN, arguments: controller.subBab),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryContainer,
              primaryContainer.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryContainer.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🎵', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lagu Matan Hafalan',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Dengarkan dan hapalkan lirik untuk mengingat point penting',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.headphones_rounded,
                  color: Colors.white, size: 24),
            ),
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
                controller.materialProgressLabel,
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
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: controller.materialProgress.clamp(0.0, 1.0),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final latsLength = controller.subBab.latihan?.length ?? 0;
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
