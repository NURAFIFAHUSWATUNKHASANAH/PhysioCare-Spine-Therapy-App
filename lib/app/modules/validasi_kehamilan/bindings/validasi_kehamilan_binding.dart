import 'package:get/get.dart';
import '../controllers/validasi_kehamilan_controller.dart';

class ValidasiKehamilanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ValidasiKehamilanController>(
      () => ValidasiKehamilanController(),
    );
  }
}