import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color onPrimaryContainer = Color(0xFF7FBDA5);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSecondaryContainer = Color(0xFF735D00);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);
  static const Color surfaceVariant = Color(0xFFE4E2DE);
  static const Color surfaceContainerHighest = Color(0xFFE3E1DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeroProfile(),
                const SizedBox(height: 24),
                _buildStreakCard(),
                const SizedBox(height: 24),
                _buildStatsGrid(),
                const SizedBox(height: 32),
                _buildXpProgressCard(),
                const SizedBox(height: 32),
                _buildAchievementsSection(),
                const SizedBox(height: 32),
                Text(
                  'Pengaturan Akun',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: onBackground.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      backgroundColor: bgBackground.withValues(alpha: 0.8),
      titleSpacing: 24,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                    onTap: () {},
                    hoverColor: surfaceVariant,
                    highlightColor: primaryContainer,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.menu_rounded, color: primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Nahwu Tutor',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: secondaryContainer, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/icon/nahwu_tutor_logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroProfile() {
    return Obx(() => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                right: -20,
                top: -10,
                child: Icon(
                  Icons.star_rounded,
                  size: 200,
                  color: surfaceContainerHigh.withValues(alpha: 0.5),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: secondary, width: 4),
                              color: surfaceContainerHighest,
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/icon/nahwu_tutor_logo.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: surfaceContainerLow, width: 3),
                              ),
                              child: Text(
                                controller.levelEmoji.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.userName.value,
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.levelName.value} (${controller.levelTitle.value})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${controller.totalXp.value} XP',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥',
                                  style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                '${controller.currentStreak.value} Hari',
                                style: GoogleFonts.plusJakartaSans(
                                  color: onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildStreakCard() {
    return Obx(() {
      final streak = controller.currentStreak.value;
      final bestStreak = controller.bestStreak.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: streak > 0
              ? secondaryContainer.withValues(alpha: 0.3)
              : surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: streak > 0
              ? Border.all(color: secondaryContainer, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: streak > 0
                    ? secondary.withValues(alpha: 0.1)
                    : surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                streak > 0 ? '🔥' : '❄️',
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streak > 0
                        ? 'Streak $streak Hari!'
                        : 'Belum Ada Streak',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    streak > 0
                        ? 'Rekor terbaik: $bestStreak hari. Terus semangat!'
                        : 'Mulai belajar hari ini untuk memulai streak!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsGrid() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.menu_book_rounded,
                title: 'Bab Selesai',
                value: '${controller.completedBab.value} / 5',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.stars_rounded,
                title: 'Total XP',
                value: '${controller.totalXp.value}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events_rounded,
                title: 'Badges',
                value: '${controller.unlockedBadges.value}',
              ),
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: secondary, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onBackground,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpProgressCard() {
    return Obx(() {
      final levelProgress = controller.levelProgress.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level Progress',
                  style: GoogleFonts.plusJakartaSans(
                    color: onPrimaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${controller.levelName.value} → ?',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: levelProgress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(levelProgress * 100).toInt()}% menuju level berikutnya',
              style: GoogleFonts.plusJakartaSans(
                color: onPrimaryContainer,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pencapaian',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: onBackground,
              ),
            ),
            Obx(() => Text(
                  '${controller.unlockedBadges.value}/${controller.achievements.length}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondary,
                  ),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.achievements.length,
              itemBuilder: (context, index) {
                final achievement = controller.achievements[index];
                final isUnlocked = achievement['unlocked'] as bool? ?? false;
                return _buildAchievementCard(achievement, isUnlocked);
              },
            )),
      ],
    );
  }

  Widget _buildAchievementCard(
      Map<String, dynamic> achievement, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? surfaceContainerLowest : surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: isUnlocked
            ? Border.all(color: secondaryContainer, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUnlocked
                ? (achievement['icon'] as String? ?? '🏆')
                : '🔒',
            style: TextStyle(
              fontSize: isUnlocked ? 28 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement['name'] as String? ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? primary : onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            achievement['desc'] as String? ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 8,
              color: isUnlocked
                  ? onSurfaceVariant
                  : onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.lock_outline_rounded,
            title: 'Ganti Password',
          ),
          const Divider(height: 1, color: surfaceContainerHigh),
          Obx(() => _buildSettingsItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifikasi Belajar',
                trailing: Switch(
                  value: controller.isNotifikasiBelajarAktif.value,
                  onChanged: controller.toggleNotifikasiBelajar,
                  activeThumbColor: Colors.white,
                  activeTrackColor: secondary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: surfaceVariant,
                ),
              )),
          const Divider(height: 1, color: surfaceContainerHigh),
          _buildSettingsItem(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi',
          ),
          const Divider(height: 1, color: surfaceContainerHigh),
          _buildSettingsItem(
            icon: Icons.logout_rounded,
            title: 'Keluar Sesi',
            isDestructive: true,
            trailing: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red[700] : primary,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: isDestructive ? Colors.red[700] : onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          (isDestructive
              ? null
              : const Icon(Icons.chevron_right_rounded,
                  color: onSurfaceVariant, size: 20)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      onTap: () {},
    );
  }
}
