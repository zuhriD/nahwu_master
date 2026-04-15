import 'package:get/get.dart';

import '../controllers/main_wrapper_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainWrapperController>(() => MainWrapperController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
