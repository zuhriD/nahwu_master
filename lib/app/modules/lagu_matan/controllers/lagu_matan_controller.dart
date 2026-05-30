import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    hide PlayerState;

import '../../../data/models/sub_bab_model.dart';

class LaguMatanController extends GetxController {
  late final SubBab subBab;

  // Audio player (for local audio)
  AudioPlayer? _audioPlayer;

  // TTS fallback when no local audio exists
  final FlutterTts _tts = FlutterTts();
  bool _ttsReady = false;

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
  String? get source => subBab.lagu?.source;
  bool get hasYoutube => youtubeId != null && youtubeId!.isNotEmpty;
  bool get hasLocalAudio => audioPath != null && audioPath!.isNotEmpty;
  bool get hasSong => lirik.isNotEmpty;
  bool get hasTextNarration => hasSong && !hasLocalAudio && !hasYoutube;

  @override
  void onInit() {
    super.onInit();
    subBab = Get.arguments as SubBab;
    _initTts();
  }

  @override
  void onClose() {
    _audioPlayer?.dispose();
    if (_ttsReady) {
      _tts.stop().catchError((_) {});
    }
    ytController?.dispose();
    super.onClose();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setCompletionHandler(() {
        isPlaying.value = false;
        isLoading.value = false;
      });

      _tts.setErrorHandler((_) {
        isPlaying.value = false;
        isLoading.value = false;
      });

      _ttsReady = true;
    } catch (e) {
      _ttsReady = false;
      debugPrint('TTS not available: $e');
    }
  }

  /// Initialize YouTube player - lazy init
  void ensureYoutubeInitialized() {
    if (_ytInitialized || !hasYoutube) return;
    try {
      isLoading.value = true;

      final videoId = YoutubePlayer.convertUrlToId(
            'https://www.youtube.com/watch?v=$youtubeId',
          ) ??
          youtubeId!;

      ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );

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
        } else if (state == PlayerState.stopped ||
            state == PlayerState.completed) {
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
    if (hasTextNarration) {
      await _toggleNarration();
      return;
    }

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
    if (hasTextNarration) {
      await _playNarration();
      return;
    }

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
    if (hasTextNarration) {
      await _tts.stop();
      isPlaying.value = false;
      isLoading.value = false;
      return;
    }

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
    if (hasTextNarration) return;

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

  Future<void> _toggleNarration() async {
    if (!_ttsReady || lirik.isEmpty) return;

    if (isPlaying.value) {
      await _tts.pause();
      isPlaying.value = false;
      return;
    }

    await _playNarration();
  }

  Future<void> _playNarration() async {
    if (!_ttsReady || lirik.isEmpty) return;

    await _tts.stop();
    isLoading.value = true;
    isPlaying.value = true;
    currentLineIndex.value = 0;
    await _tts.speak(lirik.join('\n'));
  }

  double get progress {
    if (totalDuration.value == 0) return 0;
    return playbackPosition.value / totalDuration.value;
  }
}
