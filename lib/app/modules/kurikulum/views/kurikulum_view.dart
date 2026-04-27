import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/bab_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

/// Halaman Kurikulum — menampilkan daftar bab berdasarkan kategori
/// dan bab-bab yang sudah di-bookmark
class KurikulumView extends StatelessWidget {
  const KurikulumView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color onPrimaryContainer = Color(0xFF7FBDA5);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);
  static const Color surfaceVariant = Color(0xFFE4E2DE);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final storage = Get.find<StorageService>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAllBabList(homeCtrl, storage),
                    _buildBookmarkList(homeCtrl, storage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kurikulum',
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kitab Matan Al-Jurumiyah — 5 Bab',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        labelColor: primary,
        unselectedLabelColor: onSurfaceVariant,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: secondary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: surfaceVariant,
        tabs: const [
          Tab(text: 'Semua Bab'),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_rounded, size: 16),
                SizedBox(width: 6),
                Text('Bookmark'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllBabList(HomeController homeCtrl, StorageService storage) {
    return Obx(() {
      if (homeCtrl.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: primary),
        );
      }

      final babList = homeCtrl.babList;
      if (babList.isEmpty) {
        return _buildEmptyState(
          icon: Icons.menu_book_rounded,
          title: 'Belum Ada Materi',
          subtitle: 'Materi akan muncul di sini',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        itemCount: babList.length,
        itemBuilder: (context, index) {
          final bab = babList[index];
          final isUnlocked = homeCtrl.isBabUnlocked(bab);
          final isRead =
              bab.id != null ? storage.isBabRead(bab.id!) : false;
          final isQuizDone =
              bab.id != null ? storage.isQuizDone(bab.id!) : false;
          final isBookmarked =
              bab.id != null ? storage.isBookmarked(bab.id!) : false;
          final bestScore =
              bab.id != null ? storage.getBestScore(bab.id!) : 0;

          return _BabCard(
            bab: bab,
            index: index,
            isUnlocked: isUnlocked,
            isRead: isRead,
            isQuizDone: isQuizDone,
            isBookmarked: isBookmarked,
            bestScore: bestScore,
            totalQuestions: bab.totalLatihan,
          );
        },
      );
    });
  }

  Widget _buildBookmarkList(HomeController homeCtrl, StorageService storage) {
    return Obx(() {
      final babList = homeCtrl.babList;
      final bookmarkedIds = storage.getBookmarkedBabIds();

      if (bookmarkedIds.isEmpty) {
        return _buildEmptyState(
          icon: Icons.bookmark_border_rounded,
          title: 'Belum Ada Bookmark',
          subtitle:
              'Tandai bab favorit Anda dengan menekan ikon bookmark\ndi halaman materi',
        );
      }

      final bookmarkedBabs =
          babList.where((b) => bookmarkedIds.contains(b.id)).toList();

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        itemCount: bookmarkedBabs.length,
        itemBuilder: (context, index) {
          final bab = bookmarkedBabs[index];
          final isRead =
              bab.id != null ? storage.isBabRead(bab.id!) : false;
          final isQuizDone =
              bab.id != null ? storage.isQuizDone(bab.id!) : false;
          final bestScore =
              bab.id != null ? storage.getBestScore(bab.id!) : 0;

          return _BabCard(
            bab: bab,
            index: babList.indexOf(bab),
            isUnlocked: true,
            isRead: isRead,
            isQuizDone: isQuizDone,
            isBookmarked: true,
            bestScore: bestScore,
            totalQuestions: bab.totalLatihan,
          );
        },
      );
    });
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: onSurfaceVariant.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  BAB CARD COMPONENT
// ══════════════════════════════════════════════════════════════

class _BabCard extends StatelessWidget {
  const _BabCard({
    required this.bab,
    required this.index,
    required this.isUnlocked,
    required this.isRead,
    required this.isQuizDone,
    required this.isBookmarked,
    required this.bestScore,
    required this.totalQuestions,
  });

  final Bab bab;
  final int index;
  final bool isUnlocked;
  final bool isRead;
  final bool isQuizDone;
  final bool isBookmarked;
  final int bestScore;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked
          ? () => Get.toNamed(Routes.DETAIL, arguments: bab)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked
              ? KurikulumView.surfaceContainerLowest
              : KurikulumView.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: isBookmarked
              ? Border.all(
                  color: KurikulumView.secondaryContainer, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Nomor / Status icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: _getStatusIcon()),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bab ${bab.id ?? (index + 1)}: ${bab.judul ?? ""}',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? KurikulumView.primary
                                : KurikulumView.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (isBookmarked)
                        const Icon(Icons.bookmark_rounded,
                            color: KurikulumView.secondary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildChip(_getStatusLabel(), _getChipColor()),
                      const SizedBox(width: 8),
                      if (isUnlocked && totalQuestions > 0)
                        Text(
                          '$totalQuestions soal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: KurikulumView.onSurfaceVariant,
                          ),
                        ),
                      if (isQuizDone) ...[
                        const SizedBox(width: 8),
                        Text(
                          '⭐ $bestScore/$totalQuestions',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: KurikulumView.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            if (isUnlocked)
              Icon(
                Icons.chevron_right_rounded,
                color: KurikulumView.onSurfaceVariant.withValues(alpha: 0.5),
              )
            else
              const Icon(Icons.lock_rounded,
                  color: KurikulumView.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (!isUnlocked) return KurikulumView.surfaceContainerHigh;
    if (isRead && isQuizDone) return KurikulumView.primaryContainer;
    if (isRead) return KurikulumView.secondaryContainer;
    return KurikulumView.surfaceContainerHigh;
  }

  Widget _getStatusIcon() {
    if (!isUnlocked) {
      return Text(
        '${index + 1}',
        style: GoogleFonts.plusJakartaSans(
          color: KurikulumView.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
    if (isRead && isQuizDone) {
      return const Icon(Icons.check_rounded, color: Colors.white, size: 22);
    }
    if (isRead) {
      return const Icon(Icons.auto_stories_rounded,
          color: KurikulumView.secondary, size: 20);
    }
    return Text(
      '${index + 1}',
      style: GoogleFonts.plusJakartaSans(
        color: KurikulumView.primary,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  String _getStatusLabel() {
    if (!isUnlocked) return 'TERKUNCI';
    if (isRead && isQuizDone) return 'SELESAI ✓';
    if (isRead) return 'SUDAH DIBACA';
    return 'BELUM DIBACA';
  }

  Color _getChipColor() {
    if (!isUnlocked) return KurikulumView.surfaceVariant;
    if (isRead && isQuizDone) {
      return KurikulumView.primaryContainer.withValues(alpha: 0.2);
    }
    if (isRead) return KurikulumView.secondaryContainer.withValues(alpha: 0.5);
    return KurikulumView.surfaceVariant;
  }

  Widget _buildChip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: KurikulumView.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
