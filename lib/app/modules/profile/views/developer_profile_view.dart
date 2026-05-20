import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeveloperProfileView extends StatelessWidget {
  const DeveloperProfileView({super.key});

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

  static const List<_PersonProfile> _profiles = [
    _PersonProfile(
      name: 'Abdur Rahman Frima',
      role: 'Pengembang Aplikasi',
      imagePath: 'assets/profile/developer_abdur_rahman.png',
      body:
          'Lahir di Malang pada tanggal 26 Februari 2000. Ia menempuh pendidikan dasar di MI Sunan Giri Tangkilsari (2006-2012), kemudian melanjutkan ke SMP An Nur Bululawang (2012-2015), dan SMA An Nur Bululawang (2015-2018).\n\nIa merupakan lulusan Program Studi Pendidikan Bahasa Arab (S-1) Universitas Negeri Malang dan saat ini sedang menuntaskan studi Magister pada Program Studi Keguruan Bahasa Arab di universitas yang sama. Saat ini, ia menjabat sebagai Kepala Pondok Pesantren Modern Sabilul Muhsinin Karangploso, Malang dan aktif mengajar di Madrasah Aliyah Unggulan Techno Scientist Malang.',
    ),
    _PersonProfile(
      name: 'Dr. Moh. Khasairi, M.Pd.',
      role: 'Dosen Pembimbing',
      imagePath: 'assets/profile/supervisor_khasairi.png',
      body:
          'Lahir di Malang pada tanggal 02 September 1961. Gelar Sarjana Pendidikan Bahasa Arab diperoleh dari IKIP Malang (1985), Magister Pendidikan Bahasa Indonesia dari Universitas Negeri Malang (1999), dan Doktor Pendidikan Bahasa Arab dari Universitas Islam Negeri Maulana Malik Ibrahim Malang (2016).\n\nSaat ini beliau menjadi Dosen Pendidikan Bahasa Arab pada bidang Nahwu dan Maharah Istima’ di Jurusan Sastra Arab, Fakultas Sastra, Universitas Negeri Malang, serta pengajar di Pondok Pesantren Miftahul Huda Malang. Beberapa karya beliau meliputi al Tadribat al Istima’iyah, Mawad al Nahwi ala Asasi al Nushush, dan Mawad Ta’limiyah fi Maddah Tathbiq al Nahwi al Awwal Muthawwarah ala Asasi al Nahwi al Tathbiqi Namudzaj Abdul Alim Ibrahim.',
    ),
    _PersonProfile(
      name: 'Prof. Dr. H. Imam Asrori, M.Pd.',
      role: 'Dosen Pembimbing',
      imagePath: 'assets/profile/supervisor_imam_asrori.png',
      body:
          'Lahir di Kota Pekalongan pada tanggal 15 November 1963. Gelar Sarjana Pendidikan Bahasa Arab diperoleh dari IKIP Malang pada tahun 1985. Selanjutnya, beliau menempuh pendidikan Magister Pendidikan Bahasa Indonesia di IKIP Malang dan lulus pada tahun 1998. Gelar Doktor Pendidikan Bahasa Indonesia diperoleh dari Universitas Negeri Malang pada tahun 2007.\n\nSaat ini beliau aktif sebagai dosen Pendidikan Bahasa Arab di Universitas Negeri Malang (UM), serta dikenal sebagai akademisi yang memiliki perhatian besar terhadap pengembangan pembelajaran bahasa Arab, keterampilan menulis, dan kajian kebahasaan. Beberapa buku karya beliau antara lain Indahnya Kias-Kias Al-Qur’an, Kitabah Al-Jumal, Kitabah Al-Faqrah: Menulis Paragraf Bahasa Arab, serta Dia Di Mataku.',
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
                ..._profiles.map(
                  (profile) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildProfileCard(profile),
                  ),
                ),
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
            'Profil Pengembang',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.groups_rounded, color: secondary, size: 28),
          ),
          const SizedBox(height: 18),
          Text(
            'Biografi Pengembang',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Halaman ini memuat profil pengembang aplikasi beserta riwayat dosen pembimbing yang mendampingi proses pengembangan Nahwu Tutor.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFB8D8CC),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(_PersonProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 78,
                height: 92,
                decoration: BoxDecoration(
                  color: surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: surfaceVariant),
                  image: DecorationImage(
                    image: AssetImage(profile.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.role,
                      style: GoogleFonts.plusJakartaSans(
                        color: secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.name,
                      style: GoogleFonts.manrope(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.body,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant,
              fontSize: 13,
              height: 1.72,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonProfile {
  const _PersonProfile({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.body,
  });

  final String name;
  final String role;
  final String imagePath;
  final String body;
}
