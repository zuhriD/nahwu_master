import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/lagu_matan_controller.dart';

class LaguMatanView extends GetView<LaguMatanController> {
  const LaguMatanView({super.key});

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
    return Scaffold(
      backgroundColor: bgBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // YouTube player or Song Info
                  SliverToBoxAdapter(
                    child: controller.hasYoutube
                        ? _buildYoutubeEmbed()
                        : _buildSongInfo(),
                  ),
                  // Lyrics view
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 16),
                    sliver: _buildLyricsList(),
                  ),
                ],
              ),
            ),
            // Show audio controls only if using local audio (no YouTube)
            if (!controller.hasYoutube) _buildPlayerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LAGU MATAN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: secondary,
                  ),
                ),
                Text(
                  controller.subBab.judul ?? 'Lagu Hafalan',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: controller.hasYoutube
                  ? const Color(0xFFFF0000).withValues(alpha: 0.1)
                  : secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: controller.hasYoutube
                ? const Icon(Icons.play_circle_fill_rounded,
                    color: Color(0xFFFF0000), size: 28)
                : const Text('🎵', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }

  /// YouTube embedded player via WebView
  Widget _buildYoutubeEmbed() {
    final webViewController = controller.webViewController;
    if (webViewController == null) {
      return _buildErrorCard('YouTube player gagal dimuat');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // YouTube player with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  // 16:9 aspect ratio
                  height: MediaQuery.of(Get.context!).size.width * 9 / 16 - 24,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: onBackground.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: WebViewWidget(controller: webViewController),
                ),
                // Loading overlay
                Obx(() {
                  if (!controller.isLoading.value) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    width: double.infinity,
                    height:
                        MediaQuery.of(Get.context!).size.width * 9 / 16 - 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Video info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryContainer,
                  primaryContainer.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'YouTube',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tonton video penjelasan lagu matan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Lyrics section header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(width: 24, height: 2, color: secondary),
                const SizedBox(width: 10),
                Text(
                  'Lirik Lagu',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                      '${controller.currentLineIndex.value + 1}/${controller.lirik.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceVariant,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: onSurfaceVariant, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    final lirik = controller.subBab.lagu?.lirik ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🎧 HAFALKAN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                      '${controller.currentLineIndex.value + 1}/${lirik.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onPrimaryContainer,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Dengarkan dan hapalkan lirik lagu ini untuk mengingat point-point penting dari materinya.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: onPrimaryContainer.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLyricsList() {
    final lirik = controller.subBab.lagu?.lirik ?? [];

    if (lirik.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Tidak ada lirik untuk lagu ini',
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Obx(() {
      final currentLineIndex = controller.currentLineIndex.value;

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final isCurrentLine = currentLineIndex == index;
            final isPastLine = currentLineIndex > index;

            return GestureDetector(
              onTap: () => controller.goToLine(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin:
                    const EdgeInsets.only(bottom: 8, left: 24, right: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isCurrentLine
                      ? primaryContainer
                      : isPastLine
                          ? primaryContainer.withValues(alpha: 0.3)
                          : surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: isCurrentLine
                      ? Border.all(color: secondaryContainer, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    // Line number
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCurrentLine
                            ? secondaryContainer
                            : isPastLine
                                ? primaryContainer
                                : surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrentLine
                                ? secondary
                                : isPastLine
                                    ? Colors.white
                                    : onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Lyric text
                    Expanded(
                      child: Text(
                        lirik[index],
                        style: GoogleFonts.manrope(
                          fontSize: isCurrentLine ? 17 : 15,
                          fontWeight: isCurrentLine
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCurrentLine
                              ? Colors.white
                              : isPastLine
                                  ? primary
                                  : onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                    // Status indicator
                    if (isCurrentLine) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: secondary,
                          size: 16,
                        ),
                      ),
                    ] else if (isPastLine) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        color: primaryContainer,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          childCount: lirik.length,
        ),
      );
    });
  }

  Widget _buildPlayerControls() {
    final lirik = controller.subBab.lagu?.lirik ?? [];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgBackground,
        boxShadow: [
          BoxShadow(
            color: onBackground.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          Obx(() {
            final progress = controller.progress;
            final playbackPosition = controller.playbackPosition.value;
            final totalDuration = controller.totalDuration.value;

            return Column(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(
                          Duration(milliseconds: playbackPosition.toInt())),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatDuration(
                          Duration(milliseconds: totalDuration.toInt())),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.stop_rounded,
                onTap: controller.stop,
                size: 48,
                color: surfaceVariant,
                iconColor: onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.skip_previous_rounded,
                onTap: controller.previousLine,
                size: 48,
                color: surfaceVariant,
                iconColor: primary,
              ),
              const SizedBox(width: 16),
              Obx(() {
                final isPlaying = controller.isPlaying.value;
                return GestureDetector(
                  onTap: controller.playPause,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryContainer.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.skip_next_rounded,
                onTap: controller.nextLine,
                size: 48,
                color: surfaceVariant,
                iconColor: primary,
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.replay_rounded,
                onTap: controller.play,
                size: 48,
                color: surfaceVariant,
                iconColor: primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick navigation dots
          if (lirik.length <= 8)
            Obx(() {
              final currentLineIndex = controller.currentLineIndex.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(lirik.length, (index) {
                  final isActive = currentLineIndex == index;
                  return GestureDetector(
                    onTap: () => controller.goToLine(index),
                    child: Container(
                      width: isActive ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isActive ? primaryContainer : surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 48,
    Color color = surfaceVariant,
    Color iconColor = primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 3),
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
