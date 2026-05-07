import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' hide PlayerState;

import '../../../data/models/sub_bab_model.dart';

class LaguMatanController extends GetxController {
  late final SubBab subBab;

  // Audio player (for local audio)
  AudioPlayer? _audioPlayer;

  // YouTube player controller
  YoutubePlayerController? ytController;
  bool _ytInitialized = false;

  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentLineIndex = 0.obs;
  final RxDouble playbackPosition = 0.0.obs;
  final RxDouble totalDuration = 0.0.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isYoutubeReady = false.obs;

  List<String> get lirik => subBab.lagu?.lirik ?? [];
  String? get audioPath => subBab.lagu?.audio;
  String? get youtubeId => subBab.lagu?.youtubeId;
  bool get hasYoutube => youtubeId != null && youtubeId!.isNotEmpty;
  bool get hasSong => (audioPath != null || hasYoutube) && lirik.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    subBab = Get.arguments as SubBab;
    // Lazy init YouTube/audio - only when actually needed
  }

  @override
  void onClose() {
    _audioPlayer?.dispose();
    ytController?.close();
    super.onClose();
  }

  /// Initialize YouTube player - lazy init
  void ensureYoutubeInitialized() {
    if (_ytInitialized || !hasYoutube) return;
    try {
      isLoading.value = true;
      ytController = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          showFullscreenButton: true,
          playsInline: true,
        ),
      );
      ytController!.loadVideoById(videoId: youtubeId!);
      isLoading.value = false;
      isYoutubeReady.value = true;
      _ytInitialized = true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Gagal memuat YouTube: $e';
      debugPrint('YouTube init error: $e');
    }
  }

  /// Ensure audio player is initialized (lazy init)
  Future<void> _ensureAudioInitialized() async {
    if (_audioPlayer != null) return;
    if (audioPath == null) return;

    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer!.setReleaseMode(ReleaseMode.stop);

      _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          isPlaying.value = true;
          isLoading.value = false;
        } else if (state == PlayerState.stopped || state == PlayerState.completed) {
          isPlaying.value = false;
          if (state == PlayerState.completed) {
            currentLineIndex.value = 0;
            playbackPosition.value = 0.0;
          }
        } else if (state == PlayerState.paused) {
          isPlaying.value = false;
        }
      });

      _audioPlayer!.onPositionChanged.listen((position) {
        playbackPosition.value = position.inMilliseconds.toDouble();
      });

      _audioPlayer!.onDurationChanged.listen((duration) {
        totalDuration.value = duration.inMilliseconds.toDouble();
      });

      isLoading.value = true;
      await _audioPlayer!
          .setSource(AssetSource(audioPath!.replaceFirst('assets/', '')))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Audio loading timeout');
            },
          );
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Gagal memuat audio: $e';
      debugPrint('Audio error: $e');
    }
  }

  /// Play/pause toggle (lazy init audio)
  Future<void> playPause() async {
    // Lazy init audio if needed
    if (_audioPlayer == null) {
      await _ensureAudioInitialized();
    }
    if (_audioPlayer == null) return;

    try {
      if (isPlaying.value) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.resume();
      }
    } catch (e) {
      errorMessage.value = 'Error playback: $e';
      debugPrint('Playback error: $e');
    }
  }

  /// Play from beginning (lazy init audio)
  Future<void> play() async {
    // Lazy init audio if needed
    if (_audioPlayer == null) {
      await _ensureAudioInitialized();
    }
    if (_audioPlayer == null) return;

    try {
      currentLineIndex.value = 0;
      playbackPosition.value = 0.0;
      await _audioPlayer!.seek(Duration.zero);
      await _audioPlayer!.resume();
    } catch (e) {
      errorMessage.value = 'Error play: $e';
    }
  }

  /// Stop playback (lazy init audio)
  Future<void> stop() async {
    // Lazy init audio if needed
    if (_audioPlayer == null) {
      await _ensureAudioInitialized();
    }
    if (_audioPlayer == null) return;

    try {
      await _audioPlayer!.stop();
      currentLineIndex.value = 0;
      playbackPosition.value = 0.0;
    } catch (e) {
      debugPrint('Stop error: $e');
    }
  }

  /// Seek to position (lazy init audio)
  Future<void> seek(Duration position) async {
    // Lazy init audio if needed
    if (_audioPlayer == null) {
      await _ensureAudioInitialized();
    }
    if (_audioPlayer == null) return;

    try {
      await _audioPlayer!.seek(position);
    } catch (e) {
      debugPrint('Seek error: $e');
    }
  }

  /// Auto-advance to next line
  void nextLine() {
    if (currentLineIndex.value < lirik.length - 1) {
      currentLineIndex.value++;
    }
  }

  /// Go to previous line
  void previousLine() {
    if (currentLineIndex.value > 0) {
      currentLineIndex.value--;
    }
  }

  /// Jump to specific line
  void goToLine(int index) {
    if (index >= 0 && index < lirik.length) {
      currentLineIndex.value = index;
    }
  }

  String get currentLine => currentLineIndex.value < lirik.length
      ? lirik[currentLineIndex.value]
      : '';

  double get progress {
    if (totalDuration.value == 0) return 0;
    return playbackPosition.value / totalDuration.value;
  }
}
