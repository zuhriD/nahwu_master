import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final bab = controller.bab;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Teks Inti Arab ─────────────────────────────────────
                  if (bab.teksInti != null) ...[
                    _buildSectionLabel('📜 Teks Inti', const Color(0xFF1A237E)),
                    const SizedBox(height: 10),
                    _buildArabicCard(),
                    const SizedBox(height: 20),
                  ],

                  // ── Terjemahan ─────────────────────────────────────────
                  if (bab.teksInti?.terjemahan != null) ...[
                    _buildSectionLabel('🌐 Terjemahan', const Color(0xFF0D47A1)),
                    const SizedBox(height: 10),
                    _buildTranslationCard(bab.teksInti!.terjemahan!),
                    const SizedBox(height: 20),
                  ],

                  // ── Penjelasan ─────────────────────────────────────────
                  if (bab.teksInti?.penjelasan != null) ...[
                    _buildSectionLabel('💡 Penjelasan', const Color(0xFF1B5E20)),
                    const SizedBox(height: 10),
                    _buildExplanationCard(bab.teksInti!.penjelasan!),
                    const SizedBox(height: 24),
                  ],

                  // ── Latihan Soal ───────────────────────────────────────
                  _buildQuizBanner(bab.latihan?.length ?? 0),
                  const SizedBox(height: 20),
                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SLIVER APP BAR ──────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1A237E),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF3949AB)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: 20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge bab
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Bab ${controller.bab.id ?? ''}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.bab.icon ?? '📖',
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.bab.judul ?? 'Detail Bab',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION LABEL ───────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ─── ARABIC CARD ─────────────────────────────────────────────────────────

  Widget _buildArabicCard() {
    final teksInti = controller.bab.teksInti!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ornament
          Positioned(
            right: 16,
            top: 16,
            child: Text(
              '﷽',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'نَصٌّ أَصْلِيٌّ',
                    style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 20),
                // Teks Arab
                Text(
                  teksInti.arab ?? '',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 2.2,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                // Divider
                Divider(color: Colors.white.withValues(alpha: 0.2), thickness: 1),
                const SizedBox(height: 12),
                // Latin
                if (teksInti.latin != null)
                  Text(
                    teksInti.latin!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── TRANSLATION CARD ────────────────────────────────────────────────────

  Widget _buildTranslationCard(String terjemahan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0D47A1).withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.06),
            blurRadius: 14,
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
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.translate_rounded, color: Color(0xFF1A237E), size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Arti / Terjemahan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              terjemahan,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── EXPLANATION CARD ────────────────────────────────────────────────────

  Widget _buildExplanationCard(String penjelasan) {
    // Pisah teks berdasar nomor (1), (2), (3) jika ada — buat lebih mudah dibaca
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B5E20).withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.06),
            blurRadius: 14,
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
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_rounded, color: Color(0xFF1B5E20), size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Penjelasan Lengkap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            penjelasan,
            style: const TextStyle(
              fontSize: 14,
              height: 1.85,
              color: Color(0xFF37474F),
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUIZ BANNER ─────────────────────────────────────────────────────────

  Widget _buildQuizBanner(int jumlahLatihan) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCC02).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF57F17).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF57F17).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('🧪', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latihan Soal',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF57F17),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$jumlahLatihan pertanyaan benar/salah siap dikerjakan',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF795548)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF57F17),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$jumlahLatihan Soal',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── START BUTTON ─────────────────────────────────────────────────────────

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: controller.mulaiLatihan,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Mulai Latihan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
