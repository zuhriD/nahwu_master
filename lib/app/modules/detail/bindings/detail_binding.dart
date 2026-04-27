import 'package:get/get.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    // DetailView now uses StatelessWidget directly with Get.arguments
    // No controller needed for this view
  }
}
