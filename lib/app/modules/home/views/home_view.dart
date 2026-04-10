import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bab_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const List<List<Color>> _cardGradients = [
    [Color(0xFF1A237E), Color(0xFF3949AB)],
    [Color(0xFF1B5E20), Color(0xFF388E3C)],
    [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    [Color(0xFF0D47A1), Color(0xFF1976D2)],
    [Color(0xFF880E4F), Color(0xFFC2185B)],
    [Color(0xFF004D40), Color(0xFF00796B)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildStatsBar()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: Obx(() => _buildBabSliver()),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF1A237E),
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
              // Dekorasi lingkaran besar
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Badge "Kitab Jurumiyah"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_stories, color: Colors.white70, size: 13),
                            SizedBox(width: 6),
                            Text(
                              'Kitab Jurumiyah',
                              style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Teks Arab
                      const Text(
                        'عِلْمُ النَّحْوِ',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontFamily: 'serif',
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        controller.materi.value?.judul ?? 'Nahwu Learning',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      )),
                      const SizedBox(height: 6),
                      Obx(() => Text(
                        controller.materi.value?.deskripsi ?? '',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Obx(() {
      final babCount = controller.babList.length;
      final totalLatihan = controller.babList
          .fold(0, (sum, b) => sum + (b.latihan?.length ?? 0));
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('$babCount', 'Bab', Icons.menu_book_rounded, const Color(0xFF1A237E)),
            _buildStatDivider(),
            _buildStat('$totalLatihan', 'Soal Latihan', Icons.quiz_rounded, const Color(0xFF1B5E20)),
            _buildStatDivider(),
            _buildStat('Gratis', 'Akses', Icons.lock_open_rounded, const Color(0xFF4A148C)),
          ],
        ),
      );
    });
  }

  Widget _buildStat(String value, String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatDivider() => Container(
        height: 36,
        width: 1,
        color: Colors.grey.shade200,
      );

  Widget _buildBabSliver() {
    if (controller.isLoading.value) return const SliverToBoxAdapter(child: _LoadingWidget());
    if (controller.errorMessage.value.isNotEmpty) {
      return SliverToBoxAdapter(
        child: _ErrorWidget(
          message: controller.errorMessage.value,
          onRetry: controller.loadMateri,
        ),
      );
    }
    if (controller.babList.isEmpty) {
      return const SliverToBoxAdapter(child: _EmptyWidget());
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final bab = controller.babList[index];
          final gradient = _cardGradients[index % _cardGradients.length];
          return _BabCard(bab: bab, gradient: gradient, index: index);
        },
        childCount: controller.babList.length,
      ),
    );
  }
}

// ─── BAB CARD ───────────────────────────────────────────────────────────────

class _BabCard extends StatelessWidget {
  const _BabCard({required this.bab, required this.gradient, required this.index});

  final Bab bab;
  final List<Color> gradient;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL, arguments: bab),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            children: [
              // Header strip color
              Container(
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Nomor bab + icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          bab.icon ?? '📖',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Konten
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: gradient[0].withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Bab ${bab.id ?? index + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: gradient[0],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            bab.judul ?? 'Bab ${index + 1}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A237E),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (bab.teksInti?.arab != null)
                            Text(
                              bab.teksInti!.arab!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontFamily: 'serif',
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Arrow + soal badge
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: gradient[0].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: gradient[0]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${bab.latihan?.length ?? 0} soal',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── STATE WIDGETS ───────────────────────────────────────────────────────────

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text('Memuat data materi...',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          ),
          const SizedBox(height: 16),
          const Text('Gagal Memuat Data',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Belum Ada Materi', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
