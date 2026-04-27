import 'package:get/get.dart';

import '../controllers/lagu_matan_controller.dart';

class LaguMatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaguMatanController>(() => LaguMatanController());
  }
}