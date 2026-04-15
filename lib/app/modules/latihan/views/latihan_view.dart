import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/bab_model.dart';
import '../../../data/models/latihan_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class LatihanView extends StatelessWidget {
  const LatihanView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: bgBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (homeCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: primary));
                }

                final unlockedBabs = homeCtrl.babList
                    .where((b) => homeCtrl.isBabUnlocked(b) && (b.latihan?.isNotEmpty ?? false))
                    .toList();

                if (unlockedBabs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  children: [
                    _buildCampuranCard(homeCtrl, unlockedBabs),
                    const SizedBox(height: 24),
                    Text(
                      'Latihan Spesifik per Bab',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...unlockedBabs.map((bab) => _buildBabCard(bab)).toList(),
                  ],
                );
              }),
            ),
          ],
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
            'Pusat Latihan',
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Uji wawasan Nahwu Anda melalui latihan interaktif',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.quiz_rounded,
                size: 48, color: onSurfaceVariant.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Latihan',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pelajari materi bab pertama untuk membuka sesi latihan.',
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

  Widget _buildCampuranCard(HomeController homeCtrl, List<Bab> unlockedBabs) {
    // Kumpulkan semua latihan
    final allLatihan = unlockedBabs.expand<Latihan>((b) => b.latihan ?? []).toList();
    // Acak soal
    allLatihan.shuffle();
    final mixedLatihan = allLatihan.take(10).toList(); // Ambil 10 soal acak
    
    // Buat objek Bab dummy untuk mode campuran
    final dummyBab = Bab(
      id: null, // id null -> tidak akan menyimpan progress ke specific bab, tapi tetap masuk XP jika ditambahkan
      judul: 'Latihan Campuran (Mix)',
      latihan: mixedLatihan,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryContainer.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'REKOMENDASI',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Latihan Campuran',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${mixedLatihan.length} Soal Acak (Pilihan Ganda & Benar-Salah) dari materi yang sudah Anda pelajari.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF7FBDA5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.QUIZ, arguments: dummyBab);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: surfaceContainerLow,
                foregroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded),
                  const SizedBox(width: 8),
                  Text(
                    'Mulai Mix Mode',
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
      ),
    );
  }

  Widget _buildBabCard(Bab bab) {
    final storage = Get.find<StorageService>();
    final bestScore = storage.getBestScore(bab.id!);
    final isDone = storage.isQuizDone(bab.id!);
    final total = bab.latihan?.length ?? 0;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.QUIZ, arguments: bab);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: surfaceContainerLow, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${bab.id}',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bab.judul ?? 'Materi',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildChip('$total Soal', secondaryContainer),
                      if (isDone) ...[
                        const SizedBox(width: 8),
                        _buildChip('Skor Terbaik: $bestScore', surfaceContainerLow),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
