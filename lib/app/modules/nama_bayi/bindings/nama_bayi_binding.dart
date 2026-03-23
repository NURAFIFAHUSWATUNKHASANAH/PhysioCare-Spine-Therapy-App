import 'package:get/get.dart';
import '../controllers/nama_bayi_controller.dart';

class NamaBayiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NamaBayiController>(() => NamaBayiController());
  }
}