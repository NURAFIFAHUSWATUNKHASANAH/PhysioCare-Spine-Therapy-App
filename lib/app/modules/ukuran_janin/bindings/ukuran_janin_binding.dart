import 'package:get/get.dart';
import '../controllers/ukuran_janin_controller.dart';

class UkuranJaninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UkuranJaninController>(
      () => UkuranJaninController(),
    );
  }
}