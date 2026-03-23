import 'package:get/get.dart';
import '../controllers/berat_badan_controller.dart';

class BeratBadanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeratBadanController>(() => BeratBadanController());
  }
}