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
          _buildBottomNavBar(),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Al-Mubtadi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondary,
                    ),
                  ),
                  Text(
                    'Thalabul Ilmi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: secondaryContainer, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/icon.png'), // Placeholder
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
    return Column(
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
      ],
    );
  }

  Widget _buildStatsBentoGrid() {
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
                '40% Selesai',
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Expanded(flex: 6, child: SizedBox()),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BAB TERBUKA',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '5 Bab',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SISA MATERI',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '8 Bab',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                child: const Icon(Icons.quiz_rounded, color: secondary, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                '15 Soal',
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          return _BabListItem(bab: bab, index: index);
        },
        childCount: controller.babList.length,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(bottom: 24, top: 12, left: 16, right: 16),
        decoration: BoxDecoration(
          color: bgBackground.withValues(alpha: 0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: onBackground.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, 'Beranda', isActive: true),
            _buildNavItem(Icons.menu_book_rounded, 'Kurikulum'),
            _buildNavItem(Icons.quiz_rounded, 'Latihan'),
            _buildNavItem(Icons.person_rounded, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? primary : primary.withValues(alpha: 0.5),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? primary : primary.withValues(alpha: 0.5),
            ),
          ),
        ],
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
  const _BabListItem({required this.bab, required this.index});

  final Bab bab;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Generate different styles for mocking the states in the UI design.
    // 0: Play style, 1: Locked style, others: normal style
    final int styleType = index; 

    final isLocked = styleType == 1;

    return GestureDetector(
      onTap: isLocked ? null : () => Get.toNamed(Routes.DETAIL, arguments: bab),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isLocked ? HomeView.surfaceContainerLow : HomeView.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isLocked) ...[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: HomeView.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: GoogleFonts.plusJakartaSans(
                          color: HomeView.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: HomeView.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: GoogleFonts.plusJakartaSans(
                          color: HomeView.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
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
                          color: isLocked ? HomeView.onBackground.withValues(alpha: 0.6) : HomeView.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isLocked ? HomeView.surfaceVariant : HomeView.secondaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getBadgeText(styleType),
                              style: GoogleFonts.plusJakartaSans(
                                color: isLocked ? HomeView.onSurfaceVariant : HomeView.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.quiz_outlined,
                            size: 14,
                            color: HomeView.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bab.latihan?.length ?? ((index + 1) * 3)} Soal Latihan',
                            style: GoogleFonts.plusJakartaSans(
                              color: HomeView.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isLocked && bab.teksInti?.arab != null) ...[
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
                  if (styleType == 0) ...[
                    // Play style
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.25,
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
                  ] else ...[
                    // Standard opened style
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
                    )
                  ],
                ],
              ),
            ] else if (isLocked) ...[
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

  String _getBadgeText(int index) {
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
