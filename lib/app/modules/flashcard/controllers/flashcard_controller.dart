import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/bab_model.dart';
import '../../../data/models/sub_bab_model.dart';

/// Data flashcard yang diambil dari materi bab
class FlashcardData {
  final String front; // Teks Arab / istilah
  final String back; // Terjemahan / penjelasan
  final String? latin;
  final String type; // 'matan', 'poin', 'contoh'

  FlashcardData({
    required this.front,
    required this.back,
    this.latin,
    required this.type,
  });
}

class FlashcardController extends GetxController {
  // Bisa terima Bab atau SubBab
  dynamic data;
  bool get isBab => data is Bab;
  bool get isSubBab => data is SubBab;

  final StorageService _storage = Get.find<StorageService>();
  final FlutterTts _tts = FlutterTts();

  final RxInt currentIndex = 0.obs;
  final RxBool isFlipped = false.obs;
  final RxBool isSpeaking = false.obs;
  final RxList<FlashcardData> cards = <FlashcardData>[].obs;
  final RxInt masteredCount = 0.obs;

  int get totalCards => cards.length;

  int? get dataId => isBab ? (data as Bab).id : (data as SubBab).id;

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments;
    _generateCards();
    _updateMasteredCount();
    _initTts();
  }

  @override
  void onClose() {
    if (_ttsAvailable) {
      _tts.stop().catchError((_) {});
    }
    super.onClose();
  }

  bool _ttsAvailable = false;

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      _tts.setCompletionHandler(() => isSpeaking.value = false);
      _ttsAvailable = true;
    } catch (_) {
      _ttsAvailable = false;
    }
  }

  /// Generate flashcards dari data bab atau subBab
  void _generateCards() {
    List<SubBab> subBabList = [];

    if (isBab) {
      subBabList = (data as Bab).subBab ?? [];
    } else if (isSubBab) {
      subBabList = [data as SubBab];
    }

    for (final subBab in subBabList) {
      final teksInti = subBab.teksInti;
      if (teksInti == null) continue;

      // Card 1: Matan utama
      if (teksInti.arab != null) {
        cards.add(FlashcardData(
          front: teksInti.arab!,
          back: teksInti.terjemahan ?? '',
          latin: teksInti.latin,
          type: 'matan',
        ));
      }

      // Cards dari poin-poin penjelasan
      final penjelasan = teksInti.penjelasan;
      if (penjelasan?.poinPoin != null) {
        for (final poin in penjelasan!.poinPoin!) {
          if (poin.judul != null && poin.teks != null) {
            cards.add(FlashcardData(
              front: poin.judul!,
              back: poin.teks!,
              type: 'poin',
            ));
          }
        }
      }

      // Card dari contoh
      if (penjelasan?.contoh != null) {
        final contoh = penjelasan!.contoh!;
        if (contoh.arab != null) {
          cards.add(FlashcardData(
            front: contoh.arab!,
            back: '${contoh.arti ?? ''}\n\n${contoh.catatan ?? ''}',
            type: 'contoh',
          ));
        }
      }
    }
  }

  void _updateMasteredCount() {
    if (dataId == null) return;
    masteredCount.value = _storage.getMasteredFlashcardCount(dataId!, totalCards);
  }

  /// Flip kartu
  void flipCard() {
    isFlipped.value = !isFlipped.value;
  }

  /// Kartu berikutnya
  void nextCard() {
    if (currentIndex.value < totalCards - 1) {
      currentIndex.value++;
      isFlipped.value = false;
    }
  }

  /// Kartu sebelumnya
  void previousCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      isFlipped.value = false;
    }
  }

  /// Tandai sudah hafal (swipe kanan)
  void markAsMastered() {
    if (dataId == null) return;
    _storage.setFlashcardStatus(dataId!, currentIndex.value, true);
    _storage.incrementFlashcardReviewed();
    _storage.addXp(3, 'Flashcard mastered');
    _updateMasteredCount();
    nextCard();
  }

  /// Tandai belum hafal (swipe kiri)
  void markAsNotMastered() {
    if (dataId == null) return;
    _storage.setFlashcardStatus(dataId!, currentIndex.value, false);
    _storage.incrementFlashcardReviewed();
    _updateMasteredCount();
    nextCard();
  }

  /// Cek apakah kartu saat ini sudah dikuasai
  bool get isCurrentMastered {
    if (dataId == null) return false;
    return _storage.isFlashcardMastered(dataId!, currentIndex.value);
  }

  /// Baca teks Arab
  Future<void> speak(String text) async {
    if (!_ttsAvailable) return;
    try {
      if (isSpeaking.value) {
        await _tts.stop();
        isSpeaking.value = false;
        return;
      }
      isSpeaking.value = true;
      await _tts.speak(text);
    } catch (_) {
      isSpeaking.value = false;
    }
  }

  /// Reset semua kartu
  void resetAll() {
    if (dataId == null) return;
    for (int i = 0; i < totalCards; i++) {
      _storage.setFlashcardStatus(dataId!, i, false);
    }
    currentIndex.value = 0;
    isFlipped.value = false;
    _updateMasteredCount();
  }
}