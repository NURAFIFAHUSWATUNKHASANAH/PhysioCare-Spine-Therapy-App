import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pyhsiocare/app/modules/artikel/controllers/artikel_controller.dart';
import 'package:pyhsiocare/app/modules/home/controllers/home_controller.dart';
import 'package:pyhsiocare/app/modules/jadwal/controllers/jadwal_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/services/firebase_notification_service.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:pyhsiocare/app/modules/histori/controllers/histori_controller.dart';

import 'package:pyhsiocare/config/api_config.dart';

/// Handler notifikasi ketika app dalam background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  // Tambahkan logika jika ingin handle notifikasi khusus di background
}

/// Fungsi untuk membangun aplikasi (digunakan juga untuk testing)
Widget buildApp() {
  return GetMaterialApp(
    title: "PhysioCare",
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    debugShowCheckedModeBanner: false,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // Daftarkan handler background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inisialisasi layanan notifikasi
  await FirebaseNotificationService().init();

  // Inisialisasi konfigurasi API
  ApiConfig.init();

  // Register controller global
  // Get.put(ProfileController());
  Get.put(HistoriController());
  // Get.put(HomeController());
  Get.put(ProfileController()); // kalau belum ada
  Get.put(JadwalController()); // <--- tambahkan ini
  Get.put(ArtikelController()); // kalau belum ada

  // Jalankan aplikasi
  runApp(buildApp());
}
