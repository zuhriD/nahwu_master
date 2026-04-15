import 'package:hive_flutter/hive_flutter.dart';

/// Service utama untuk mengelola penyimpanan lokal menggunakan Hive.
/// Digunakan sebagai singleton via GetX.
class StorageService {
  static const String _progressBoxName = 'progress';
  static const String _prefsBoxName = 'user_prefs';
  static const String _achievementsBoxName = 'achievements';
  static const String _bookmarksBoxName = 'bookmarks';

  late Box _progressBox;
  late Box _prefsBox;
  late Box _achievementsBox;
  late Box _bookmarksBox;

  /// Inisialisasi Hive dan buka semua box
  Future<void> init() async {
    await Hive.initFlutter();
    _progressBox = await Hive.openBox(_progressBoxName);
    _prefsBox = await Hive.openBox(_prefsBoxName);
    _achievementsBox = await Hive.openBox(_achievementsBoxName);
    _bookmarksBox = await Hive.openBox(_bookmarksBoxName);
  }

  // ════════════════════════════════════════════════════════════
  //  PROGRESS TRACKING
  // ════════════════════════════════════════════════════════════

  /// Tandai bab sebagai sudah dibaca
  void markBabAsRead(int babId) {
    _progressBox.put('bab_${babId}_read', true);
    _progressBox.put('bab_${babId}_readAt', DateTime.now().toIso8601String());
    _addXp(50, 'Membaca Bab $babId');
  }

  /// Cek apakah bab sudah dibaca
  bool isBabRead(int babId) {
    return _progressBox.get('bab_${babId}_read', defaultValue: false);
  }

  /// Simpan hasil quiz
  void saveQuizResult(int babId, int score, int total) {
    final int prevBest = getBestScore(babId);
    _progressBox.put('bab_${babId}_quizDone', true);
    _progressBox.put('bab_${babId}_lastScore', score);
    _progressBox.put('bab_${babId}_totalQuestions', total);
    _progressBox.put('bab_${babId}_quizAt', DateTime.now().toIso8601String());

    final int attempts = getQuizAttempts(babId) + 1;
    _progressBox.put('bab_${babId}_attempts', attempts);

    if (score > prevBest) {
      _progressBox.put('bab_${babId}_bestScore', score);
    }

    // Berikan XP berdasarkan skor
    final double pct = score / total * 100;
    if (pct == 100) {
      _addXp(100, 'Perfect Score Bab $babId');
    } else if (pct >= 80) {
      _addXp(50, 'Quiz Bab $babId (≥80%)');
    } else if (pct >= 60) {
      _addXp(30, 'Quiz Bab $babId (≥60%)');
    } else {
      _addXp(10, 'Quiz Bab $babId');
    }

    // Check achievements setelah quiz
    _checkQuizAchievements(babId, score, total);
  }

  /// Cek apakah quiz bab sudah selesai
  bool isQuizDone(int babId) {
    return _progressBox.get('bab_${babId}_quizDone', defaultValue: false);
  }

  /// Ambil skor terbaik quiz bab
  int getBestScore(int babId) {
    return _progressBox.get('bab_${babId}_bestScore', defaultValue: 0);
  }

  /// Ambil jumlah percobaan quiz
  int getQuizAttempts(int babId) {
    return _progressBox.get('bab_${babId}_attempts', defaultValue: 0);
  }

  /// Cek apakah bab terbuka (unlocked)
  /// Bab 1 selalu terbuka. Bab selanjutnya terbuka jika bab sebelumnya
  /// sudah dibaca DAN quiz-nya selesai.
  bool isBabUnlocked(int babId, int totalQuestions) {
    if (babId <= 1) return true;
    final int prevId = babId - 1;
    final bool prevRead = isBabRead(prevId);
    final bool prevQuizDone = isQuizDone(prevId);
    
    // Cukup pastikan sudah dibaca dan kuis sudah pernah dikerjakan
    return prevRead && prevQuizDone;
  }

  /// Hitung jumlah bab yang sudah selesai (dibaca + quiz done)
  int getCompletedBabCount(int totalBab) {
    int count = 0;
    for (int i = 1; i <= totalBab; i++) {
      if (isBabRead(i) && isQuizDone(i)) count++;
    }
    return count;
  }

  /// Hitung jumlah bab yang sudah dibaca
  int getReadBabCount(int totalBab) {
    int count = 0;
    for (int i = 1; i <= totalBab; i++) {
      if (isBabRead(i)) count++;
    }
    return count;
  }

  // ════════════════════════════════════════════════════════════
  //  XP & LEVELING SYSTEM
  // ════════════════════════════════════════════════════════════

  /// Tambah XP
  void _addXp(int amount, String reason) {
    final int current = getTotalXp();
    _prefsBox.put('totalXp', current + amount);

    // Log XP history (simpan 50 terakhir)
    List<dynamic> history = _prefsBox.get('xpHistory', defaultValue: <dynamic>[]);
    history.add({
      'amount': amount,
      'reason': reason,
      'time': DateTime.now().toIso8601String(),
    });
    if (history.length > 50) {
      history = history.sublist(history.length - 50);
    }
    _prefsBox.put('xpHistory', history);
  }

  /// Tambah XP secara publik (untuk flashcard, dll)
  void addXp(int amount, String reason) => _addXp(amount, reason);

  /// Ambil total XP
  int getTotalXp() {
    return _prefsBox.get('totalXp', defaultValue: 0);
  }

  /// Ambil level saat ini berdasarkan XP
  Map<String, dynamic> getCurrentLevel() {
    final int xp = getTotalXp();
    final levels = [
      {'level': 1, 'name': 'Al-Mubtadi', 'title': 'Pemula', 'minXp': 0, 'emoji': '🌱'},
      {'level': 2, 'name': 'Thalibul Ilmi', 'title': 'Pencari Ilmu', 'minXp': 500, 'emoji': '📖'},
      {'level': 3, 'name': "Al-Muta'allim", 'title': 'Pelajar', 'minXp': 1500, 'emoji': '✏️'},
      {'level': 4, 'name': 'Al-Faahim', 'title': 'Pemahami', 'minXp': 3500, 'emoji': '💡'},
      {'level': 5, 'name': 'Al-Mutqin', 'title': 'Mahir', 'minXp': 7000, 'emoji': '⭐'},
      {'level': 6, 'name': "Al-'Aalim", 'title': 'Berilmu', 'minXp': 12000, 'emoji': '🏅'},
      {'level': 7, 'name': 'Al-Ustadz', 'title': 'Pengajar', 'minXp': 20000, 'emoji': '👑'},
    ];

    Map<String, dynamic> current = levels.first;
    Map<String, dynamic>? next;

    for (int i = 0; i < levels.length; i++) {
      if (xp >= (levels[i]['minXp'] as int)) {
        current = levels[i];
        next = (i + 1 < levels.length) ? levels[i + 1] : null;
      }
    }

    final int nextMinXp = next != null ? (next['minXp'] as int) : (current['minXp'] as int);
    final int currentMinXp = current['minXp'] as int;
    final double progress = next != null
        ? (xp - currentMinXp) / (nextMinXp - currentMinXp)
        : 1.0;

    return {
      ...current,
      'xp': xp,
      'nextLevel': next,
      'progress': progress.clamp(0.0, 1.0),
    };
  }

  // ════════════════════════════════════════════════════════════
  //  DAILY STREAK
  // ════════════════════════════════════════════════════════════

  /// Update streak harian
  void updateDailyStreak() {
    final String today = _dateKey(DateTime.now());
    final String? lastActive = _prefsBox.get('lastActiveDate');

    if (lastActive == today) return; // Sudah diupdate hari ini

    final String yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    int streak = _prefsBox.get('streakDays', defaultValue: 0);

    if (lastActive == yesterday) {
      streak++;
      _addXp(20, 'Streak Harian ($streak hari)');
    } else if (lastActive != today) {
      streak = 1; // Reset streak
    }

    _prefsBox.put('streakDays', streak);
    _prefsBox.put('lastActiveDate', today);

    // Track best streak
    final int bestStreak = _prefsBox.get('bestStreak', defaultValue: 0);
    if (streak > bestStreak) {
      _prefsBox.put('bestStreak', streak);
    }

    // Simpan tanggal aktif untuk kalender
    List<dynamic> activeDates = _prefsBox.get('activeDates', defaultValue: <dynamic>[]);
    if (!activeDates.contains(today)) {
      activeDates.add(today);
      // Keep last 90 days
      if (activeDates.length > 90) {
        activeDates = activeDates.sublist(activeDates.length - 90);
      }
      _prefsBox.put('activeDates', activeDates);
    }

    _checkStreakAchievements(streak);
  }

  /// Ambil streak saat ini
  int getCurrentStreak() {
    final String today = _dateKey(DateTime.now());
    final String yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    final String? lastActive = _prefsBox.get('lastActiveDate');

    if (lastActive == today || lastActive == yesterday) {
      return _prefsBox.get('streakDays', defaultValue: 0);
    }
    return 0; // Streak putus
  }

  /// Ambil best streak
  int getBestStreak() {
    return _prefsBox.get('bestStreak', defaultValue: 0);
  }

  /// Ambil daftar tanggal aktif
  List<String> getActiveDates() {
    final List<dynamic> dates = _prefsBox.get('activeDates', defaultValue: <dynamic>[]);
    return dates.cast<String>();
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // ════════════════════════════════════════════════════════════
  //  ACHIEVEMENTS / BADGES
  // ════════════════════════════════════════════════════════════

  /// Daftar semua achievement yang tersedia
  static List<Map<String, dynamic>> get allAchievements => [
        {
          'id': 'first_read',
          'icon': '📖',
          'name': 'Pembaca Pertama',
          'desc': 'Baca materi bab pertama',
        },
        {
          'id': 'sharpshooter',
          'icon': '🎯',
          'name': 'Sharpshooter',
          'desc': 'Perfect score di quiz manapun',
        },
        {
          'id': 'streak_3',
          'icon': '🔥',
          'name': 'Mulai Terbakar!',
          'desc': 'Streak 3 hari berturut-turut',
        },
        {
          'id': 'streak_7',
          'icon': '🔥',
          'name': 'On Fire!',
          'desc': 'Streak 7 hari berturut-turut',
        },
        {
          'id': 'streak_30',
          'icon': '🌟',
          'name': 'Istiqamah!',
          'desc': 'Streak 30 hari berturut-turut',
        },
        {
          'id': 'bookworm',
          'icon': '📚',
          'name': 'Kutu Buku',
          'desc': 'Baca 5 bab materi',
        },
        {
          'id': 'quiz_master',
          'icon': '🏆',
          'name': 'Sang Juara',
          'desc': 'Selesaikan semua quiz',
        },
        {
          'id': 'perfectionist',
          'icon': '💎',
          'name': 'Perfectionist',
          'desc': 'Perfect score di semua quiz',
        },
        {
          'id': 'xp_500',
          'icon': '⭐',
          'name': 'Bintang Baru',
          'desc': 'Kumpulkan 500 XP',
        },
        {
          'id': 'xp_2000',
          'icon': '🌙',
          'name': 'Pejuang Ilmu',
          'desc': 'Kumpulkan 2000 XP',
        },
        {
          'id': 'flashcard_50',
          'icon': '🃏',
          'name': 'Card Master',
          'desc': 'Review 50 flashcard',
        },
        {
          'id': 'retry_king',
          'icon': '🔄',
          'name': 'Pantang Menyerah',
          'desc': 'Ulangi quiz 3x di satu bab',
        },
      ];

  /// Unlock sebuah achievement
  /// Returns true jika baru diunlock (untuk trigger animasi)
  bool unlockAchievement(String achievementId) {
    if (isAchievementUnlocked(achievementId)) return false;
    _achievementsBox.put(achievementId, DateTime.now().toIso8601String());
    _addXp(50, 'Achievement: $achievementId');
    return true;
  }

  /// Cek apakah achievement sudah diunlock
  bool isAchievementUnlocked(String achievementId) {
    return _achievementsBox.containsKey(achievementId);
  }

  /// Ambil daftar achievement yang sudah diunlock
  List<String> getUnlockedAchievements() {
    return _achievementsBox.keys.cast<String>().toList();
  }

  /// Ambil jumlah achievement yang sudah diunlock
  int getUnlockedCount() {
    return _achievementsBox.length;
  }

  /// Check quiz-related achievements
  void _checkQuizAchievements(int babId, int score, int total) {
    // Sharpshooter: perfect score
    if (score == total) {
      unlockAchievement('sharpshooter');
    }

    // Retry king: 3+ attempts
    if (getQuizAttempts(babId) >= 3) {
      unlockAchievement('retry_king');
    }

    // XP-based achievements
    final int xp = getTotalXp();
    if (xp >= 500) unlockAchievement('xp_500');
    if (xp >= 2000) unlockAchievement('xp_2000');
  }

  /// Check streak-related achievements
  void _checkStreakAchievements(int streak) {
    if (streak >= 3) unlockAchievement('streak_3');
    if (streak >= 7) unlockAchievement('streak_7');
    if (streak >= 30) unlockAchievement('streak_30');
  }

  /// Check read-related achievements (panggil setelah markBabAsRead)
  void checkReadAchievements(int totalBab) {
    final int readCount = getReadBabCount(totalBab);
    if (readCount >= 1) unlockAchievement('first_read');
    if (readCount >= 5) unlockAchievement('bookworm');

    // XP-based
    final int xp = getTotalXp();
    if (xp >= 500) unlockAchievement('xp_500');
    if (xp >= 2000) unlockAchievement('xp_2000');
  }

  // ════════════════════════════════════════════════════════════
  //  BOOKMARKS
  // ════════════════════════════════════════════════════════════

  /// Toggle bookmark untuk sebuah bab
  bool toggleBookmark(int babId) {
    if (isBookmarked(babId)) {
      _bookmarksBox.delete('bab_$babId');
      return false;
    } else {
      _bookmarksBox.put('bab_$babId', DateTime.now().toIso8601String());
      return true;
    }
  }

  /// Cek apakah bab di-bookmark
  bool isBookmarked(int babId) {
    return _bookmarksBox.containsKey('bab_$babId');
  }

  /// Ambil daftar bab yang di-bookmark
  List<int> getBookmarkedBabIds() {
    return _bookmarksBox.keys
        .cast<String>()
        .where((k) => k.startsWith('bab_'))
        .map((k) => int.parse(k.replaceFirst('bab_', '')))
        .toList();
  }

  // ════════════════════════════════════════════════════════════
  //  FLASHCARD PROGRESS
  // ════════════════════════════════════════════════════════════

  /// Simpan status flashcard (sudah hafal / belum)
  void setFlashcardStatus(int babId, int cardIndex, bool mastered) {
    _progressBox.put('fc_${babId}_$cardIndex', mastered);
  }

  /// Cek apakah flashcard sudah dihafal
  bool isFlashcardMastered(int babId, int cardIndex) {
    return _progressBox.get('fc_${babId}_$cardIndex', defaultValue: false);
  }

  /// Hitung jumlah flashcard yang sudah dihafal dari 1 bab
  int getMasteredFlashcardCount(int babId, int totalCards) {
    int count = 0;
    for (int i = 0; i < totalCards; i++) {
      if (isFlashcardMastered(babId, i)) count++;
    }
    return count;
  }

  /// Increment total flashcard reviewed (untuk achievement)
  void incrementFlashcardReviewed() {
    final int current = _prefsBox.get('totalFlashcardReviewed', defaultValue: 0);
    _prefsBox.put('totalFlashcardReviewed', current + 1);
    if (current + 1 >= 50) {
      unlockAchievement('flashcard_50');
    }
  }

  /// Ambil total flashcard reviewed
  int getTotalFlashcardReviewed() {
    return _prefsBox.get('totalFlashcardReviewed', defaultValue: 0);
  }

  // ════════════════════════════════════════════════════════════
  //  USER PREFERENCES
  // ════════════════════════════════════════════════════════════

  /// Set nama user
  void setUserName(String name) => _prefsBox.put('userName', name);

  /// Get nama user
  String getUserName() => _prefsBox.get('userName', defaultValue: 'Thalabul Ilmi');

  /// Set notifikasi
  void setNotification(bool active) => _prefsBox.put('notifActive', active);

  /// Get notifikasi
  bool getNotification() => _prefsBox.get('notifActive', defaultValue: true);

  /// Cek apakah first time user (untuk onboarding)
  bool isFirstTime() => _prefsBox.get('isFirstTime', defaultValue: true);

  /// Set first time = false
  void setNotFirstTime() => _prefsBox.put('isFirstTime', false);
}
