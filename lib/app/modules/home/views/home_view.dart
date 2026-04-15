import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/bab_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color onPrimaryContainer = Color(0xFF7FBDA5);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSecondaryContainer = Color(0xFF735D00);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);
  static const Color surfaceVariant = Color(0xFFE4E2DE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeroWelcome(),
                    const SizedBox(height: 32),
                    _buildStatsBentoGrid(),
                    const SizedBox(height: 32),
                    _buildChapterListTitle(),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                sliver: Obx(() => _buildBabSliver()),
              ),
            ],
          ),
          _buildFloatingActionButton(),
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
                    onTap: () {},
                    hoverColor: surfaceVariant,
                    highlightColor: primaryContainer,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.menu_rounded, color: primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Nahwu Master',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.levelName.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: secondary,
                        ),
                      ),
                      Text(
                        controller.levelTitle.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: secondaryContainer, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/icon.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroWelcome() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ahlan wa Sahlan,',
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mari lanjutkan perjalanan ilmu Nahwu Anda hari ini.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: onSurfaceVariant,
              ),
            ),
            if (controller.currentStreak.value > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'Streak ${controller.currentStreak.value} hari!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ));
  }

  Widget _buildStatsBentoGrid() {
    return Obx(() {
      final pct = (controller.progressPercent.value * 100).toInt();
      final completed = controller.completedBab.value;
      final total = controller.totalBab;
      final remaining = total - completed;

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kemajuan Belajar',
                  style: GoogleFonts.plusJakartaSans(
                    color: onPrimaryContainer,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pct% Selesai',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: controller.progressPercent.value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatChip('BAB SELESAI', '$completed Bab'),
                    const SizedBox(width: 16),
                    _buildStatChip('SISA MATERI', '$remaining Bab'),
                    const SizedBox(width: 16),
                    _buildStatChip('TOTAL XP', '${controller.totalXp.value}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: secondaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.quiz_rounded, color: secondary, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  '${controller.totalAvailableQuiz} Soal',
                  style: GoogleFonts.manrope(
                    color: secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tersedia untuk dikerjakan',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSecondaryContainer,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Mulai Latihan',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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

  Widget _buildStatChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 9,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterListTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kurikulum Utama',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: secondary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Lihat Semua',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBabSliver() {
    if (controller.isLoading.value) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(color: primary),
        ),
      );
    }
    if (controller.errorMessage.value.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text(controller.errorMessage.value)),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final bab = controller.babList[index];
          final isUnlocked = controller.isBabUnlocked(bab);
          final isRead = bab.id != null ? controller.isBabRead(bab.id!) : false;
          final isQuizDone =
              bab.id != null ? controller.isQuizDone(bab.id!) : false;
          final bestScore =
              bab.id != null ? controller.getBestScore(bab.id!) : 0;

          return _BabListItem(
            bab: bab,
            index: index,
            isUnlocked: isUnlocked,
            isRead: isRead,
            isQuizDone: isQuizDone,
            bestScore: bestScore,
          );
        },
        childCount: controller.babList.length,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 112,
      right: 24,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _BabListItem extends StatelessWidget {
  const _BabListItem({
    required this.bab,
    required this.index,
    required this.isUnlocked,
    required this.isRead,
    required this.isQuizDone,
    required this.bestScore,
  });

  final Bab bab;
  final int index;
  final bool isUnlocked;
  final bool isRead;
  final bool isQuizDone;
  final int bestScore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked
          ? () => Get.toNamed(Routes.DETAIL, arguments: bab)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isUnlocked
              ? HomeView.surfaceContainerLowest
              : HomeView.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isUnlocked && isRead && isQuizDone
                        ? HomeView.primaryContainer
                        : HomeView.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isUnlocked && isRead && isQuizDone
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 24)
                        : Text(
                            (index + 1).toString().padLeft(2, '0'),
                            style: GoogleFonts.plusJakartaSans(
                              color: isUnlocked
                                  ? HomeView.primary
                                  : HomeView.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bab ${bab.id ?? (index + 1)}: ${bab.judul ?? ""}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? HomeView.primary
                              : HomeView.onBackground.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildBadge(),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.quiz_outlined,
                            size: 14,
                            color: HomeView.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bab.latihan?.length ?? 0} Soal Latihan',
                            style: GoogleFonts.plusJakartaSans(
                              color: HomeView.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (isUnlocked && isQuizDone) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Skor terbaik: $bestScore/${bab.latihan?.length ?? 0}',
                          style: GoogleFonts.plusJakartaSans(
                            color: HomeView.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isUnlocked && bab.teksInti?.arab != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      bab.teksInti!.arab!,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        color: HomeView.primary.withValues(alpha: 0.8),
                        fontSize: 26,
                        height: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (isRead && !isQuizDone) ...[
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: bestScore > 0
                                ? bestScore / (bab.latihan?.length ?? 1)
                                : 0.25,
                            strokeWidth: 3,
                            color: HomeView.secondary,
                            backgroundColor: HomeView.surfaceContainerHigh,
                          ),
                          const Icon(
                            Icons.play_circle_filled_rounded,
                            color: HomeView.secondary,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ] else if (!isRead) ...[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: HomeView.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: HomeView.primary,
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: HomeView.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ] else if (!isUnlocked) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    color: HomeView.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    String text;
    Color bgColor;
    Color textColor;

    if (!isUnlocked) {
      text = 'TERKUNCI';
      bgColor = HomeView.surfaceVariant;
      textColor = HomeView.onSurfaceVariant;
    } else if (isRead && isQuizDone) {
      text = 'SELESAI ✓';
      bgColor = HomeView.primaryContainer.withValues(alpha: 0.2);
      textColor = HomeView.primaryContainer;
    } else if (isRead) {
      text = 'SUDAH DIBACA';
      bgColor = HomeView.secondaryContainer.withValues(alpha: 0.5);
      textColor = HomeView.secondary;
    } else {
      text = _getCategoryLabel();
      bgColor = HomeView.secondaryContainer.withValues(alpha: 0.5);
      textColor = HomeView.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getCategoryLabel() {
    switch (index) {
      case 0:
        return 'MUQADDIMAH';
      case 1:
        return 'DASAR';
      case 2:
        return 'INTI';
      default:
        return 'LANJUTAN';
    }
  }
}
