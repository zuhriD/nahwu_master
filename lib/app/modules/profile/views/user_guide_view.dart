import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserGuideView extends StatelessWidget {
  const UserGuideView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color onPrimaryContainer = Color(0xFF7FBDA5);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);
  static const Color surfaceVariant = Color(0xFFE4E2DE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHero(),
                const SizedBox(height: 24),
                _buildSummaryRow(),
                const SizedBox(height: 28),
                _buildSection(
                  title: 'Gambaran Umum',
                  icon: Icons.auto_stories_rounded,
                  child: Text(
                    'Nahwu Tutor adalah aplikasi pembelajaran nahwu berbasis Android yang dirancang untuk membantu peserta didik memahami dasar-dasar ilmu nahwu secara sistematis, interaktif, dan mudah dipahami. Aplikasi ini memadukan literatur turats dengan multimedia pembelajaran modern agar belajar terasa lebih hidup dan mandiri.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.75,
                      color: onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Struktur Materi',
                  icon: Icons.view_list_rounded,
                  child: Column(
                    children: [
                      _buildStructureCard(
                        number: '01',
                        title: 'Bab Kalam',
                        desc:
                            'Kalam, Pembagian Kalimah, Tanda-Tanda Isim, Tanda-Tanda Fi’il, Tanda-Tanda Huruf.',
                      ),
                      const SizedBox(height: 12),
                      _buildStructureCard(
                        number: '02',
                        title: 'Bab I’rab',
                        desc:
                            'I’rab dan Pembagiannya, I’rab yang Berlaku pada Isim, I’rab yang Berlaku pada Fi’il.',
                      ),
                      const SizedBox(height: 12),
                      _buildStructureCard(
                        number: '03',
                        title: 'Bab Mengetahui Tanda-Tanda I’rab',
                        desc:
                            'Tanda-Tanda I’rab Rafa’, Nashab, Khafad, dan Jazm.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Fitur Utama',
                  icon: Icons.widgets_rounded,
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.menu_book_rounded,
                        title: 'Teks asli kitab',
                        desc:
                            'Setiap materi memuat redaksi asli dari kitab-kitab nahwu klasik.',
                        tint: primaryContainer,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.map_rounded,
                        title: 'Mind mapping',
                        desc:
                            'Kerangka konsep ditampilkan agar alur pembahasan lebih mudah diikuti.',
                        tint: secondary,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.play_circle_fill_rounded,
                        title: 'Video pembelajaran',
                        desc:
                            'Materi dilengkapi video YouTube untuk penjelasan yang lebih konkret.',
                        tint: primary,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.travel_explore_rounded,
                        title: 'Contoh Al-Qur’an',
                        desc:
                            'Contoh penerapan kaidah disajikan dari ayat-ayat Al-Qur’an.',
                        tint: secondaryContainer,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.music_note_rounded,
                        title: 'Audio lagu',
                        desc:
                            'Audio hafalan membantu mengingat kaidah dengan cara yang lebih ringan.',
                        tint: primaryContainer,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.quiz_rounded,
                        title: 'Latihan soal',
                        desc:
                            'Latihan interaktif disediakan di akhir materi untuk mengukur pemahaman.',
                        tint: secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Langkah Penggunaan',
                  icon: Icons.alt_route_rounded,
                  child: Column(
                    children: [
                      _buildStepItem(
                        number: 1,
                        title: 'Buka aplikasi',
                        desc:
                            'Tekan ikon Nahwu Tutor untuk memulai penggunaan.',
                      ),
                      _buildStepItem(
                        number: 2,
                        title: 'Masuk ke beranda',
                        desc:
                            'Pilih menu utama seperti Kurikulum, Latihan Soal, atau Profil Aplikasi.',
                      ),
                      _buildStepItem(
                        number: 3,
                        title: 'Pilih bab dan materi',
                        desc:
                            'Masuk ke kurikulum lalu pilih bab dan sub-bab yang ingin dipelajari.',
                      ),
                      _buildStepItem(
                        number: 4,
                        title: 'Pelajari isi materi',
                        desc:
                            'Baca teks, lihat mind map, tonton video, dan dengarkan audio pembelajaran.',
                      ),
                      _buildStepItem(
                        number: 5,
                        title: 'Kerjakan latihan',
                        desc:
                            'Gunakan latihan soal untuk mengecek pemahaman setelah belajar.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Cara Belajar yang Disarankan',
                  icon: Icons.lightbulb_rounded,
                  child: Column(
                    children: const [
                      _TipChip(
                        text: 'Pelajari materi secara bertahap dan berurutan.',
                      ),
                      _TipChip(
                        text:
                            'Mulai dari mind mapping agar gambaran besar materinya lebih cepat masuk.',
                      ),
                      _TipChip(
                        text:
                            'Dengarkan audio lagu berulang untuk membantu hafalan.',
                      ),
                      _TipChip(
                        text:
                            'Selesaikan video pembelajaran sampai tuntas agar konteksnya utuh.',
                      ),
                      _TipChip(
                        text:
                            'Kerjakan latihan secara mandiri lalu ulangi materi yang belum dipahami.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Penutup',
                  icon: Icons.verified_rounded,
                  child: Text(
                    'Melalui integrasi materi turats, multimedia pembelajaran, dan latihan interaktif, Nahwu Tutor diharapkan menjadi media belajar yang efektif, menyenangkan, dan mendukung pembelajaran mandiri.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.75,
                      color: onSurfaceVariant,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 6,
      shadowColor: onBackground.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgBackground.withValues(alpha: 0.84),
      titleSpacing: 24,
      title: Row(
        children: [
          Text(
            'Panduan Penggunaan',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            primaryContainer,
            primaryContainer.withValues(alpha: 0.86),
            secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mulai dari sini',
                      style: GoogleFonts.plusJakartaSans(
                        color: onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Panduan cepat memakai aplikasi',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Panduan ini membantu pengguna memahami alur belajar, fitur utama, dan langkah pemakaian aplikasi dengan cepat.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryChip(
            icon: Icons.view_in_ar_rounded,
            label: '3 Bab',
            color: primaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryChip(
            icon: Icons.play_circle_rounded,
            label: 'Video + Audio',
            color: secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryChip(
            icon: Icons.assignment_turned_in_rounded,
            label: 'Latihan',
            color: primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryContainer, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  Widget _buildStructureCard({
    required String number,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: secondary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.65,
                    color: onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color tint,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.65,
                    color: onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int number,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.65,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipChip extends StatelessWidget {
  const _TipChip({required this.text});

  final String text;

  static const Color bg = Color(0xFFF5F3EF);
  static const Color primary = Color(0xFF003526);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.65,
                color: Color(0xFF3F4945),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
