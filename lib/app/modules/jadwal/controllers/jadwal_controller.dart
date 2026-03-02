import 'package:get/get.dart';
import '../views/jadwal_dialog.dart';

class JadwalController extends GetxController {
  void showJadwalDialog() {
    Get.dialog(JadwalDialog(), barrierDismissible: false);
  }
}
