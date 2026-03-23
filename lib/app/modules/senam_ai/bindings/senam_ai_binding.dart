import 'package:get/get.dart';
import '../controllers/senam_ai_controller.dart';

class SenamAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SenamAiController>(() => SenamAiController());
  }
}