import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pyhsiocare/app/modules/histori/views/histori_view.dart';
import 'package:pyhsiocare/app/modules/home/views/home_view.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:pyhsiocare/app/modules/profil/views/profil_view.dart';
import 'package:pyhsiocare/app/modules/terapi/views/terapi_view.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pyhsiocare/app/modules/histori/controllers/histori_controller.dart'; // Tambahkan ini

class HomeController extends GetxController {
  var totalLatihan = 0.obs;
  var totalWaktuLatihan = "".obs;
  var selectedIndex = 0.obs;

  final pages = <Widget>[
    HomeView(),
    TerapiView(),
    HistoriView(),
    ProfileView(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() async {
    super.onInit();

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      print("Belum login, tidak fetch data");
      return;
    }

    fetchUserData();
    fetchHistori();
    getTotalLatihanDanWaktu();

    // final historiController = Get.find<HistoriController>();
    Get.put(HistoriController());
  }

  void fetchUserData() {
    final profileController = Get.find<ProfileController>();
    print('Nama pengguna: ${profileController.namaC.value}');
  }

  void fetchHistori() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) return;

    final url = Uri.parse('${ApiConfig.baseUrl}/histori/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      totalLatihan.value = data.length;

      final totalSeconds = data.length * 30;
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;

      if (hours > 0) {
        totalWaktuLatihan.value = '$hours jam ${minutes} menit';
      } else {
        totalWaktuLatihan.value = '$minutes menit';
      }
    } else {
      print('Gagal mengambil data histori: ${response.body}');
    }
  }

Future<void> getTotalLatihanDanWaktu() async {
  final prefs = await SharedPreferences.getInstance();

  final userId = prefs.getString('user_id');

  if (userId == null) return;

  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/histori/stats/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Gunakan fallback 0 jika null
      totalLatihan.value = (data['totalLatihan'] ?? 0) as int;

      // Gunakan fallback string kosong jika null
      totalWaktuLatihan.value = (data['totalDurasi'] ?? '').toString();
    } else {
      print('Gagal mengambil data histori: ${response.body}');
    }
  } catch (e) {
    print('Error saat mengambil total latihan: $e');
    totalLatihan.value = 0;
    totalWaktuLatihan.value = '';
  }
}
}
