import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/main_wrapper_controller.dart';
import '../../home/views/home_view.dart';
import '../../kurikulum/views/kurikulum_view.dart';
import '../../latihan/views/latihan_view.dart';
import '../../profile/views/profile_view.dart';

class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color onBackground = Color(0xFF1B1C1A);
  static const Color primary = Color(0xFF003526);
  static const Color secondaryContainer = Color(0xFFFDD755);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: Stack(
        children: [
          Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                const HomeView(),
                const KurikulumView(),
                const LatihanView(),
                const ProfileView(),
              ],
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }


  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(bottom: 24, top: 12, left: 16, right: 16),
        decoration: BoxDecoration(
          color: bgBackground.withValues(alpha: 0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: onBackground.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.menu_book_rounded, 'Kurikulum'),
              _buildNavItem(2, Icons.quiz_rounded, 'Latihan'),
              _buildNavItem(3, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? primary : primary.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? primary : primary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
