import 'package:get/get.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';

class ProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
