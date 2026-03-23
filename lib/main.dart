import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pyhsiocare/app/modules/artikel/controllers/artikel_controller.dart';
import 'package:pyhsiocare/app/modules/home/controllers/home_controller.dart';
import 'package:pyhsiocare/app/modules/jadwal/controllers/jadwal_controller.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:pyhsiocare/app/modules/histori/controllers/histori_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/services/firebase_notification_service.dart';
import 'package:pyhsiocare/config/api_config.dart';


/// ===============================
/// BACKGROUND NOTIFICATION HANDLER
/// ===============================
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  print("Background message diterima:");
  print("Message ID: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");

}

/// ===============================
/// BUILD APP
/// ===============================
Widget buildApp() {
  return GetMaterialApp(
    title: "PregMate",
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    debugShowCheckedModeBanner: false,
  );
}

/// ===============================
/// MAIN FUNCTION
/// ===============================
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// ===============================
  /// INIT FIREBASE
  /// ===============================
  await Firebase.initializeApp();


  /// ===============================
  /// REQUEST PERMISSION NOTIFICATION
  /// ===============================
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );


  /// ===============================
  /// BACKGROUND HANDLER
  /// ===============================
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler
  );


  /// ===============================
  /// INIT FIREBASE NOTIFICATION SERVICE
  /// ===============================
  await FirebaseNotificationService().init();


  /// ===============================
  /// LISTENER NOTIF SAAT APP TERBUKA
  /// ===============================
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    print("NOTIF MASUK");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");

    if (message.notification != null) {

      Get.snackbar(
        message.notification!.title ?? "Notifikasi",
        message.notification!.body ?? "",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

    }

  });


  /// ===============================
  /// LISTENER KETIKA NOTIF DIKLIK
  /// ===============================
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    print("Notifikasi diklik oleh user");

    // contoh redirect
    Get.toNamed(Routes.INFORMASI);

  });


  /// ===============================
  /// INIT API CONFIG
  /// ===============================
  ApiConfig.init();


  /// ===============================
  /// REGISTER GLOBAL CONTROLLER
  /// ===============================
  Get.put(HistoriController());
  Get.put(ProfileController());
  Get.put(JadwalController());
  Get.put(ArtikelController());
  Get.put(HomeController());


  /// ===============================
  /// RUN APP
  /// ===============================
  runApp(buildApp());

}