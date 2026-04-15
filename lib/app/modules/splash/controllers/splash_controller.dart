import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // onReady dipanggil setelah frame pertama render — navigator sudah siap
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    print("🔥 PINDAH KE HOME");

    // Gunakan named route agar konsisten dengan konfigurasi getPages
    Get.offAllNamed(Routes.MAIN_WRAPPER);
  }
}
