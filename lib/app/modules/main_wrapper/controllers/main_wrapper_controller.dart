import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainWrapperController extends GetxController {
  final selectedIndex = 0.obs;

  void changePage(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;

    // Refresh stats saat berpindah tab
    if (index == 0) {
      // Home tab
      try {
        Get.find<HomeController>().refreshStats();
      } catch (_) {}
    } else if (index == 3) {
      // Profile tab
      try {
        Get.find<ProfileController>().refreshStats();
      } catch (_) {}
    }
  }
}
