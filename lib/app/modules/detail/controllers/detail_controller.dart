import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/bab_model.dart';
import '../../../routes/app_pages.dart';

class DetailController extends GetxController {
  late final Bab bab;

  @override
  void onInit() {
    super.onInit();
    bab = Get.arguments as Bab;
  }

  void mulaiLatihan() {
    if (bab.latihan == null || bab.latihan!.isEmpty) {
      Get.snackbar(
        'Informasi',
        'Belum ada soal latihan untuk bab ini.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A237E),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    Get.toNamed(Routes.QUIZ, arguments: bab);
  }
}
