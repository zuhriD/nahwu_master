import 'package:get/get.dart';

import '../controllers/sub_bab_controller.dart';

class SubBabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubBabController>(() => SubBabController());
  }
}