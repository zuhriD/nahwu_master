import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE4E2DE);

  static const List<_AboutSection> _sections = [
    _AboutSection(
      icon: Icons.auto_stories_rounded,
      title: 'Media Pembelajaran Nahwu',
      body:
          'Nahwu Tutor merupakan aplikasi pembelajaran Nahwu berbasis Android yang dikembangkan sebagai media pembelajaran yang interaktif dan inovatif terhadap kebutuhan pembelajaran era digital. Aplikasi ini dirancang untuk membantu santri dan peserta didik memahami kaidah-kaidah nahwu secara lebih sistematis, menarik, dan mudah dipahami melalui integrasi berbagai fitur multimedia pembelajaran.',
    ),
    _AboutSection(
      icon: Icons.menu_book_rounded,
      title: 'Berbasis Sumber Klasik',
      body:
          'Sebagai bentuk penguatan autentisitas materi, Nahwu Tutor memuat redaksi teks asli yang bersumber dari kitab-kitab nahwu klasik, seperti Al-Jurumiyah dan Al-Nahwu Al-Wadih. Penyajian sumber asli tersebut bertujuan untuk membiasakan peserta didik berinteraksi langsung dengan literatur bahasa Arab klasik sekaligus menjaga kesinambungan tradisi keilmuan dalam pembelajaran nahwu.',
    ),
    _AboutSection(
      icon: Icons.account_tree_rounded,
      title: 'Visual, Video, dan Audio',
      body:
          'Nahwu Tutor dilengkapi dengan fitur mind mapping setiap materi, video pembelajaran dari YouTube, serta lirik dan audio lagu pembelajaran yang disajikan sesuai pokok bahasan nahwu. Perpaduan ini membantu peserta didik memahami hubungan antar konsep, memvisualisasikan penjelasan materi, dan menguatkan daya hafal.',
    ),
    _AboutSection(
      icon: Icons.format_quote_rounded,
      title: 'Contoh Kontekstual',
      body:
          'Aplikasi ini menghadirkan berbagai contoh kalimat yang bersumber dari Al-Qur’an sehingga pembelajaran nahwu tidak hanya bersifat teoritis, tetapi juga kontekstual dan bernilai religius.',
    ),
    _AboutSection(
      icon: Icons.quiz_rounded,
      title: 'Latihan Interaktif',
      body:
          'Setiap pembahasan dilengkapi dengan latihan soal interaktif untuk meningkatkan pembelajaran mandiri secara aktif serta mengukur tingkat pemahaman peserta didik terhadap materi yang telah dipelajari.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHero(),
                const SizedBox(height: 24),
                ..._sections.map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildSectionCard(section),
                  ),
                ),
                const SizedBox(height: 10),
                _buildClosingCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: onBackground.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgBackground.withValues(alpha: 0.86),
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_rounded, color: primary),
          ),
          Text(
            'Tentang Aplikasi',
            style: GoogleFonts.manrope(
              color: primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
        color: primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: secondaryContainer, width: 3),
              image: const DecorationImage(
                image: AssetImage('assets/icon/logo_new.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nahwu Tutor',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Media pembelajaran Nahwu yang memadukan teks klasik, mind mapping, video, audio, dan latihan interaktif.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFB8D8CC),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(_AboutSection section) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: secondaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(section.icon, color: secondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: GoogleFonts.manrope(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.body,
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceVariant,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: surfaceVariant),
      ),
      child: Text(
        'Melalui perpaduan unsur visual, audio, dan interaktivitas pembelajaran, Nahwu Tutor diharapkan dapat menjadi media pembelajaran yang efektif, menarik, dan mampu mendukung peningkatan kualitas pembelajaran nahwu di lingkungan pendidikan formal maupun pesantren.',
        style: GoogleFonts.plusJakartaSans(
          color: onBackground,
          fontSize: 14,
          height: 1.7,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _AboutSection {
  const _AboutSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}
