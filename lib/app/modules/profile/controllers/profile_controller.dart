import 'package:get/get.dart';

import '../../../data/local/storage_service.dart';

class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final isNotifikasiBelajarAktif = true.obs;

  // Real stats
  final RxInt totalXp = 0.obs;
  final RxInt completedBab = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt bestStreak = 0.obs;
  final RxString levelName = 'Al-Mubtadi'.obs;
  final RxString levelTitle = 'Pemula'.obs;
  final RxString levelEmoji = '🌱'.obs;
  final RxDouble levelProgress = 0.0.obs;
  final RxInt unlockedBadges = 0.obs;
  final RxString userName = 'Thalabul Ilmi'.obs;

  // Achievements list
  final RxList<Map<String, dynamic>> achievements = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    isNotifikasiBelajarAktif.value = _storage.getNotification();
    userName.value = _storage.getUserName();
    refreshStats();
  }

  void refreshStats() {
    totalXp.value = _storage.getTotalXp();
    completedBab.value = _storage.getCompletedBabCount(5); // Current total bab
    currentStreak.value = _storage.getCurrentStreak();
    bestStreak.value = _storage.getBestStreak();

    final level = _storage.getCurrentLevel();
    levelName.value = level['name'] as String;
    levelTitle.value = level['title'] as String;
    levelEmoji.value = level['emoji'] as String;
    levelProgress.value = level['progress'] as double;

    unlockedBadges.value = _storage.getUnlockedCount();

    // Build achievements list with unlock status
    final allAchievements = StorageService.allAchievements;
    achievements.value = allAchievements.map((a) {
      return {
        ...a,
        'unlocked': _storage.isAchievementUnlocked(a['id'] as String),
      };
    }).toList();
  }

  void toggleNotifikasiBelajar(bool value) {
    isNotifikasiBelajarAktif.value = value;
    _storage.setNotification(value);
  }

  void updateUserName(String name) {
    userName.value = name;
    _storage.setUserName(name);
  }

  /// Get daftar bookmark
  List<int> get bookmarkedBabIds => _storage.getBookmarkedBabIds();

  /// Get active dates for calendar
  List<String> get activeDates => _storage.getActiveDates();
}
