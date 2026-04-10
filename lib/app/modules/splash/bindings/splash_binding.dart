import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Gunakan Get.put (bukan lazyPut) agar controller langsung dibuat
    // saat binding dijalankan. lazyPut menunda pembuatan sampai ada yang
    // memanggil controller — karena SplashView tidak memanggil apapun
    // dari controller, onReady() tidak pernah dipanggil.
    Get.put<SplashController>(SplashController());
  }
}
