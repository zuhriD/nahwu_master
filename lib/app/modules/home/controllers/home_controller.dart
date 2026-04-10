import 'package:get/get.dart';

import '../../../data/models/bab_model.dart';
import '../../../data/models/materi_model.dart';
import '../../../data/services/json_service.dart';

class HomeController extends GetxController {
  final JsonService _jsonService = JsonService();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<Materi> materi = Rxn<Materi>();

  List<Bab> get babList => materi.value?.bab ?? [];

  @override
  void onInit() {
    super.onInit();
    loadMateri();
  }

  Future<void> loadMateri() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _jsonService.loadMateri();
      materi.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
