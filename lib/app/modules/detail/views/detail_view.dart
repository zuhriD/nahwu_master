import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/models/bab_model.dart';
import '../../../data/models/sub_bab_model.dart';
import '../../../routes/app_pages.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

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
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late final Bab bab;
  YoutubePlayerController? _ytController;
  bool _ytInitialized = false;

  @override
  void initState() {
    super.initState();
    bab = Get.arguments as Bab;
  }

  void _initYoutubePlayer() {
    if (_ytInitialized) return;
    try {
      final videoId = YoutubePlayer.convertUrlToId(
            'https://www.youtube.com/watch?v=${bab.youtubeId}',
          ) ??
          bab.youtubeId ??
          '';

      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );
      _ytInitialized = true;
    } catch (e) {
      debugPrint('YouTube init error: $e');
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DetailView.bgBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(bab),
              SliverPadding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 24, bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBabHeader(bab),
                    if (bab.hasYoutube) ...[
                      const SizedBox(height: 24),
                      _buildYoutubeSection(),
                    ],
                    if (_mindMapSubBab(bab).isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _buildMindMapGallery(bab),
                    ],
                    const SizedBox(height: 32),
                    _buildSubBabList(bab),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Bab bab) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: DetailView.onBackground.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      backgroundColor: DetailView.bgBackground.withValues(alpha: 0.8),
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
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
                onTap: () => Get.back(),
                hoverColor: DetailView.surfaceVariant,
                highlightColor: DetailView.primaryContainer,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 16),
                  child:
                      Icon(Icons.arrow_back_rounded, color: DetailView.primary),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BAB ${bab.id ?? ""}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: DetailView.secondary,
                ),
              ),
              Text(
                bab.judul ?? 'Detail Bab',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  color: DetailView.primary,
                  fontSize: 18,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBabHeader(Bab bab) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DetailView.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                bab.icon ?? '📘',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bab.judul ?? 'Bab ${bab.id}',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (bab.deskripsi != null) ...[
            Text(
              bab.deskripsi!,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            '${bab.subBab?.length ?? 0} Sub Bab • ${bab.totalLatihan} Soal Latihan',
            style: GoogleFonts.plusJakartaSans(
              color: DetailView.onPrimaryContainer,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0,
            backgroundColor: DetailView.primary.withValues(alpha: 0.3),
            valueColor:
                AlwaysStoppedAnimation<Color>(DetailView.secondaryContainer),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  /// YouTube video embed section
  Widget _buildYoutubeSection() {
    // Lazy init YouTube player only when widget is visible
    if (!_ytInitialized && bab.hasYoutube) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initYoutubePlayer();
        setState(() {});
      });
    }
    if (_ytController == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(width: 32, height: 2, color: DetailView.secondary),
            const SizedBox(width: 12),
            Text(
              'Video Penjelasan',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DetailView.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow_rounded,
                      color: Color(0xFFFF0000), size: 14),
                  const SizedBox(width: 2),
                  Text(
                    'YouTube',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF0000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // YouTube player
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: DetailView.onBackground.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: YoutubePlayer(
              controller: _ytController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: DetailView.secondaryContainer,
              progressColors: const ProgressBarColors(
                playedColor: DetailView.secondaryContainer,
                handleColor: DetailView.secondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Video caption
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: DetailView.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: DetailView.onSurfaceVariant, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tonton video penjelasan materi bab ini untuk pemahaman lebih mudah',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: DetailView.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubBabList(Bab bab) {
    final subBabList = bab.subBab ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 2,
              color: DetailView.secondary,
            ),
            const SizedBox(width: 12),
            Text(
              'Daftar Sub Bab',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DetailView.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...subBabList.asMap().entries.map((entry) {
          final subBab = entry.value;
          final isLast = entry.key == subBabList.length - 1;
          return _SubBabItem(
            subBab: subBab,
            babIndex: bab.id ?? (entry.key + 1),
            isLast: isLast,
          );
        }),
      ],
    );
  }

  List<SubBab> _mindMapSubBab(Bab bab) {
    return (bab.subBab ?? [])
        .where((subBab) => subBab.mindMapImagePath != null)
        .toList();
  }

  Widget _buildMindMapGallery(Bab bab) {
    final items = _mindMapSubBab(bab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 32, height: 2, color: DetailView.secondary),
            const SizedBox(width: 12),
            Text(
              'Mind Mapping',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DetailView.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final subBab = items[index];
              final imagePath = subBab.mindMapImagePath!;

              return GestureDetector(
                onTap: () => _showMindMapDialog(
                  context,
                  imagePath: imagePath,
                  title: subBab.mindMapTitle ?? subBab.judul ?? 'Mind Mapping',
                ),
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: DetailView.onBackground.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: DetailView.surfaceContainerLow,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildMissingMindMapPreview(imagePath);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subBab.mindMapTitle ?? 'Mind Mapping',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: DetailView.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subBab.judul ?? 'Sub Bab',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: DetailView.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMissingMindMapPreview(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported_rounded,
            color: DetailView.onSurfaceVariant,
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(
            imagePath,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: DetailView.onSurfaceVariant,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMindMapDialog(
    BuildContext context, {
    required String imagePath,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 14, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: DetailView.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: DetailView.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 5,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildMissingMindMapPreview(imagePath),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubBabItem extends StatelessWidget {
  const _SubBabItem({
    required this.subBab,
    required this.babIndex,
    required this.isLast,
  });

  final SubBab subBab;
  final int babIndex;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SUB_BAB, arguments: subBab),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number circle
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DetailView.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      subBab.icon ?? '📖',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: DetailView.surfaceContainerHigh,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DetailView.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subBab.judul ?? 'Sub Bab ${subBab.id}',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: DetailView.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: DetailView.secondaryContainer
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${subBab.latihan?.length ?? 0} Soal',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: DetailView.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (subBab.teksInti?.arab != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        subBab.teksInti!.arab!,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          color: DetailView.primary.withValues(alpha: 0.8),
                          fontSize: 22,
                          height: 1.6,
                        ),
                      ),
                    ],
                    if (subBab.teksInti?.terjemahan != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subBab.teksInti!.terjemahan!,
                        style: GoogleFonts.plusJakartaSans(
                          color: DetailView.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: DetailView.primaryContainer
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Baca Materi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: DetailView.primaryContainer,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: DetailView.primaryContainer,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
