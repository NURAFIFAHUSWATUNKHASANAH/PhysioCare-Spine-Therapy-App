import 'package:get/get.dart';
import 'package:pyhsiocare/app/modules/artikel/controllers/artikel_controller.dart';
import 'package:pyhsiocare/app/modules/histori/controllers/histori_controller.dart';
import 'package:pyhsiocare/app/modules/jadwal/controllers/jadwal_controller.dart';
import 'package:pyhsiocare/app/modules/mood/controllers/mood_controller.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import '../../keluhan/controllers/keluhan_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());       // langsung buat instance
    Get.put<KeluhanController>(KeluhanController());
    Get.put<JadwalController>(JadwalController());   // <-- pakai Get.put agar langsung tersedia
    Get.put<ArtikelController>(ArtikelController());
    Get.put<ProfileController>(ProfileController());
    Get.put<HistoriController>(HistoriController());
    Get.put<MoodController>(MoodController());
  }
}