import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Buat channel notifikasi Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel', // harus sama dengan backend dan AndroidManifest.xml
    'Default Channel',
    importance: Importance.high,
  );

  Future<void> init() async {
    // Minta izin notifikasi (iOS & Android 13+)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Inisialisasi plugin local notifications
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Buat dan daftarkan notification channel Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Handle notifikasi saat app berjalan (foreground)
    FirebaseMessaging.onMessage.listen(_showNotification);

    // Handle notifikasi saat app dibuka dari background/terminated lewat notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification opened: ${message.notification?.title}');
      // Bisa tambah navigasi ke halaman tertentu di sini
    });

    // Ambil token FCM untuk disimpan ke server/database
    final token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');
  }

  void _showNotification(RemoteMessage message) {
    // Detail notifikasi Android (harus sesuai channel yang sudah dibuat)
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',  // harus sama dengan yang didaftarkan
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    // Tampilkan notifikasi
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Notifikasi',
      message.notification?.body ?? '',
      platformDetails,
    );
  }
}
