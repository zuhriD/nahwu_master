import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/sub_bab_model.dart';
import '../../../routes/app_pages.dart';

class SubBabController extends GetxController {
  late final SubBab subBab;
  final StorageService _storage = Get.find<StorageService>();
  final FlutterTts _tts = FlutterTts();

  bool _ttsReady = false;

  // Bookmark state
  final RxBool isBookmarked = false.obs;

  // TTS state
  final RxBool isSpeaking = false.obs;
  final RxDouble ttsSpeed = 0.4.obs;

  @override
  void onInit() {
    super.onInit();
    subBab = Get.arguments as SubBab;

    // Mark sub bab as read
    if (subBab.id != null) {
      isBookmarked.value = _storage.isBookmarked(subBab.id!);
    }

    _initTts();
  }

  @override
  void onClose() {
    if (_ttsReady) {
      _tts.stop().catchError((_) {});
    }
    super.onClose();
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

  /// Toggle bookmark
  void toggleBookmark() {
    if (subBab.id == null) return;
    final result = _storage.toggleBookmark(subBab.id!);
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
}
