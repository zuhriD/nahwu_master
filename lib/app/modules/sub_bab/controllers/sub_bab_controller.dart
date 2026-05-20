import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    hide PlayerState;

import '../../../data/local/storage_service.dart';
import '../../../data/models/sub_bab_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class SubBabController extends GetxController {
  late final SubBab subBab;
  final StorageService _storage = Get.find<StorageService>();
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  YoutubePlayerController? ytController;

  bool _ttsReady = false;
  bool _audioReady = false;
  bool _ytInitialized = false;

  // Bookmark state
  final RxBool isBookmarked = false.obs;

  // TTS state
  final RxBool isSpeaking = false.obs;
  final RxBool isAudioPlaying = false.obs;
  final RxBool isAudioLoading = false.obs;
  final RxBool isYoutubeReady = false.obs;
  final RxString youtubeError = ''.obs;
  final RxDouble ttsSpeed = 0.4.obs;

  @override
  void onInit() {
    super.onInit();
    subBab = Get.arguments as SubBab;

    final progressId = subBab.progressId;
    if (progressId != null) {
      isBookmarked.value = _storage.isBookmarked(progressId);
      _storage.markBabAsRead(progressId);
      _refreshHomeProgress();
    }

    _initTts();
  }

  @override
  void onClose() {
    if (_ttsReady) {
      _tts.stop().catchError((_) {});
    }
    _audioPlayer.dispose();
    ytController?.dispose();
    super.onClose();
  }

  bool get hasYoutubeVideo {
    final url = subBab.youtubeUrl;
    final id = subBab.youtubeId;
    return (url != null && url.isNotEmpty) || (id != null && id.isNotEmpty);
  }

  void ensureYoutubeInitialized() {
    if (_ytInitialized || !hasYoutubeVideo) return;

    try {
      final videoId = YoutubePlayer.convertUrlToId(subBab.youtubeUrl ?? '') ??
          subBab.youtubeId ??
          '';
      if (videoId.isEmpty) return;

      ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );
      _ytInitialized = true;
      isYoutubeReady.value = true;
    } catch (e) {
      youtubeError.value = 'Gagal memuat video: $e';
      debugPrint('YouTube init error: $e');
    }
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(ttsSpeed.value);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setCompletionHandler(() {
        isSpeaking.value = false;
      });

      _tts.setErrorHandler((msg) {
        isSpeaking.value = false;
      });

      _ttsReady = true;
    } catch (e) {
      _ttsReady = false;
      debugPrint('TTS not available: $e');
    }
  }

  Future<void> toggleMaterialAudio() async {
    final audioPath = subBab.materialAudioPath;
    if (audioPath == null || audioPath.isEmpty) return;

    try {
      if (isAudioPlaying.value) {
        await _audioPlayer.pause();
        return;
      }

      isAudioLoading.value = true;
      if (!_audioReady) {
        _audioPlayer.onPlayerStateChanged.listen((state) {
          isAudioPlaying.value = state == PlayerState.playing;
          if (state == PlayerState.completed || state == PlayerState.stopped) {
            isAudioPlaying.value = false;
          }
        });
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.setSource(
          AssetSource(audioPath.replaceFirst('assets/', '')),
        );
        _audioReady = true;
      }
      await _audioPlayer.resume();
    } catch (e) {
      Get.snackbar(
        'Audio belum bisa diputar',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE4E2DE),
        colorText: const Color(0xFF1B1C1A),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isAudioLoading.value = false;
    }
  }

  /// Baca teks Arab menggunakan TTS
  Future<void> speakArabic(String text) async {
    if (!_ttsReady) return;
    try {
      if (isSpeaking.value) {
        await _tts.stop();
        isSpeaking.value = false;
        return;
      }

      isSpeaking.value = true;
      await _tts.setSpeechRate(ttsSpeed.value);
      await _tts.speak(text);
    } catch (e) {
      isSpeaking.value = false;
    }
  }

  /// Toggle kecepatan TTS
  void toggleSpeed() {
    if (ttsSpeed.value <= 0.3) {
      ttsSpeed.value = 0.5;
    } else if (ttsSpeed.value <= 0.5) {
      ttsSpeed.value = 0.7;
    } else {
      ttsSpeed.value = 0.3;
    }
  }

  String get speedLabel {
    if (ttsSpeed.value <= 0.3) return '0.5x';
    if (ttsSpeed.value <= 0.5) return '1x';
    return '1.5x';
  }

  double get materialProgress {
    final progressId = subBab.progressId;
    if (progressId == null) return 0;
    if (_storage.isQuizDone(progressId)) return 1;
    if (_storage.isBabRead(progressId)) return 0.5;
    return 0;
  }

  String get materialProgressLabel {
    final percent = (materialProgress * 100).round();
    return '$percent% Selesai';
  }

  /// Toggle bookmark
  void toggleBookmark() {
    final progressId = subBab.progressId;
    if (progressId == null) return;
    final result = _storage.toggleBookmark(progressId);
    isBookmarked.value = result;

    Get.snackbar(
      result ? 'Ditandai 📌' : 'Tandai Dihapus',
      result
          ? 'Sub bab ${subBab.judul} ditambahkan ke bookmark'
          : 'Sub bab ${subBab.judul} dihapus dari bookmark',
      snackPosition: SnackPosition.TOP,
      backgroundColor:
          result ? const Color(0xFF054D3A) : const Color(0xFFE4E2DE),
      colorText: result ? Colors.white : const Color(0xFF1B1C1A),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
    );
  }

  void mulaiLatihan() {
    if (subBab.latihan == null || subBab.latihan!.isEmpty) {
      Get.snackbar(
        'Informasi',
        'Belum ada soal latihan untuk sub bab ini.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF054D3A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    Get.toNamed(Routes.QUIZ, arguments: subBab);
  }

  void _refreshHomeProgress() {
    try {
      Get.find<HomeController>().refreshStats();
    } catch (_) {}
  }
}
