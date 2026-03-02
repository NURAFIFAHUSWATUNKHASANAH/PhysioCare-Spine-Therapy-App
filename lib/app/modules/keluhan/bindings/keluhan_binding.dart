import 'package:get/get.dart';
import '../controllers/keluhan_controller.dart';

class KeluhanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeluhanController>(() => KeluhanController());
  }
}
