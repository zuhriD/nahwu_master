import 'package:get/get.dart';

import '../../../data/local/storage_service.dart';
import '../../../data/models/bab_model.dart';
import '../../../data/models/materi_model.dart';
import '../../../data/services/json_service.dart';

class HomeController extends GetxController {
  final JsonService _jsonService = JsonService();
  final StorageService _storage = Get.find<StorageService>();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<Materi> materi = Rxn<Materi>();

  // Real progress data
  final RxInt completedBab = 0.obs;
  final RxInt readBab = 0.obs;
  final RxDouble progressPercent = 0.0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt totalXp = 0.obs;
  final RxString levelName = 'Al-Mubtadi'.obs;
  final RxString levelTitle = 'Pemula'.obs;

  // Reactive trigger — increment ini untuk paksa rebuild UI bab list
  final RxInt _refreshTrigger = 0.obs;

  // Newly unlocked achievements (for showing popup)
  final RxList<Map<String, dynamic>> newAchievements = <Map<String, dynamic>>[].obs;

  List<Bab> get babList => materi.value?.bab ?? [];
  int get totalBab => babList.length;

  @override
  void onInit() {
    super.onInit();
    loadMateri();
  }

  @override
  void onReady() {
    super.onReady();
    refreshStats();
  }

  Future<void> loadMateri() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _jsonService.loadMateri();
      materi.value = result;
      refreshStats();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh semua statistik dari storage
  void refreshStats() {
    if (babList.isEmpty) return;

    completedBab.value = _storage.getCompletedBabCount(totalBab);
    readBab.value = _storage.getReadBabCount(totalBab);
    progressPercent.value = totalBab > 0 ? completedBab.value / totalBab : 0.0;
    currentStreak.value = _storage.getCurrentStreak();
    totalXp.value = _storage.getTotalXp();

    final level = _storage.getCurrentLevel();
    levelName.value = level['name'] as String;
    levelTitle.value = level['title'] as String;

    // Trigger rebuild pada bab list
    _refreshTrigger.value++;
  }

  /// Cek apakah bab terbuka — baca _refreshTrigger agar reactive
  bool isBabUnlocked(Bab bab) {
    // ignore: unused_local_variable
    final _ = _refreshTrigger.value; // Subscribe ke Obx
    if (bab.id == null) return true;
    return _storage.isBabUnlocked(bab.id!, bab.latihan?.length ?? 0);
  }

  /// Cek apakah bab sudah dibaca
  bool isBabRead(int babId) {
    // ignore: unused_local_variable
    final _ = _refreshTrigger.value;
    return _storage.isBabRead(babId);
  }

  /// Cek apakah quiz bab sudah selesai
  bool isQuizDone(int babId) {
    // ignore: unused_local_variable
    final _ = _refreshTrigger.value;
    return _storage.isQuizDone(babId);
  }

  /// Ambil skor terbaik quiz
  int getBestScore(int babId) {
    // ignore: unused_local_variable
    final _ = _refreshTrigger.value;
    return _storage.getBestScore(babId);
  }

  /// Hitung jumlah total soal latihan yang tersedia
  int get totalAvailableQuiz {
    int total = 0;
    for (final bab in babList) {
      if (isBabUnlocked(bab)) {
        total += bab.latihan?.length ?? 0;
      }
    }
    return total;
  }
}
