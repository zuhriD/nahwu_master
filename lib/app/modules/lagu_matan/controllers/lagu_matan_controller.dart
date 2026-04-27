import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/sub_bab_model.dart';

class LaguMatanController extends GetxController {
  late final SubBab subBab;

  // Audio player (for local audio)
  AudioPlayer? _audioPlayer;

  // WebView controller (for YouTube embed)
  WebViewController? webViewController;

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
    if (hasYoutube) {
      _initYoutubeWebView();
    } else {
      _initAudio();
    }
  }

  @override
  void onClose() {
    _audioPlayer?.dispose();
    super.onClose();
  }

  /// Initialize YouTube via WebView with iframe embed
  void _initYoutubeWebView() {
    try {
      isLoading.value = true;

      final embedHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #000; overflow: hidden; }
    .video-container {
      position: relative;
      width: 100%;
      padding-bottom: 56.25%; /* 16:9 */
      height: 0;
    }
    .video-container iframe {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: 0;
    }
  </style>
</head>
<body>
  <div class="video-container">
    <iframe
      src="https://www.youtube.com/embed/$youtubeId?playsinline=1&rel=0&modestbranding=1"
      title="YouTube video player"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      referrerpolicy="strict-origin-when-cross-origin"
      allowfullscreen>
    </iframe>
  </div>
</body>
</html>
''';

      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              isLoading.value = false;
              isYoutubeReady.value = true;
            },
            onWebResourceError: (error) {
              isLoading.value = false;
              errorMessage.value = 'Gagal memuat video: ${error.description}';
              debugPrint('WebView error: ${error.description}');
            },
          ),
        )
        ..loadHtmlString(embedHtml);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Gagal memuat YouTube: $e';
      debugPrint('YouTube WebView init error: $e');
    }
  }

  /// Initialize local audio player
  Future<void> _initAudio() async {
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

  /// Play/pause toggle (only for local audio mode)
  Future<void> playPause() async {
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

  /// Play from beginning (only for local audio mode)
  Future<void> play() async {
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

  /// Stop playback (only for local audio mode)
  Future<void> stop() async {
    if (_audioPlayer == null) return;

    try {
      await _audioPlayer!.stop();
      currentLineIndex.value = 0;
      playbackPosition.value = 0.0;
    } catch (e) {
      debugPrint('Stop error: $e');
    }
  }

  /// Seek to position (only for local audio mode)
  Future<void> seek(Duration position) async {
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
