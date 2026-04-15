import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  static const Color bgBackground = Color(0xFFFBF9F5);
  static const Color primary = Color(0xFF003526);
  static const Color primaryContainer = Color(0xFF054D3A);
  static const Color secondary = Color(0xFF725C00);
  static const Color secondaryContainer = Color(0xFFFDD755);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color surfaceVariant = Color(0xFFE4E2DE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBackground,
      body: Stack(
        children: [
          // Background Pattern
          _buildBackgroundPattern(),
          
          // Mandala Top Left
          Positioned(
            top: -50,
            left: -50,
            child: Icon(
              Icons.blur_on_rounded, // Placeholder for the mandala
              size: 250,
              color: surfaceVariant.withValues(alpha: 0.5),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: primaryContainer.withValues(alpha: 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: secondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Nahwu Master',
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: primary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    "Pintu Utama Menuju Bahasa Al-Qur'an",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Progress Bar manually styled or use LinearProgressIndicator
                  Container(
                    width: 200,
                    height: 6,
                    decoration: BoxDecoration(
                      color: surfaceVariant,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      // For illustrative purposes moving to 30%, just like the design
                      widthFactor: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Loading Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sync_rounded,
                        size: 14,
                        color: onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Menyiapkan Kurikulum...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                  
                  // Footer Pill
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: surfaceVariant,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'THE MODERN MAJLIS',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: onSurfaceVariant.withValues(alpha: 0.6),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return IgnorePointer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return Center(
            child: Icon(
              Icons.star_rounded, // Assuming four-pointed star approximation
              size: 24,
              color: surfaceVariant.withValues(alpha: 0.3),
            ),
          );
        },
      ),
    );
  }
}
