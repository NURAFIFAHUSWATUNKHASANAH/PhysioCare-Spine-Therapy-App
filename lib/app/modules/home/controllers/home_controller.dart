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

  var usiaMinggu = 0.obs;
  var usiaHari = 0.obs;
  var trimester = 0.obs;
  var hpl = "".obs;

  var hpht = "".obs;
var tinggiBadan = "".obs;
var beratBadan = "".obs;
var riwayatPenyakit = "".obs;

  var ukuranJanin = "".obs;
  var perkembanganJanin = "".obs;
  var tipsKesehatan = "".obs;

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
    fetchDashboardKehamilan();

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
  final token = prefs.getString('auth_token');

  if (userId == null || userId.isEmpty) return;

  final url = Uri.parse('${ApiConfig.baseUrl}/histori/$userId');

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
  );

  if (response.statusCode == 200) {

    final Map<String, dynamic> result = jsonDecode(response.body);
    final List data = result["data"] ?? [];

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
  final token = prefs.getString('auth_token');

  if (userId == null) return;

  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/histori/stats/$userId'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      totalLatihan.value = (data['totalLatihan'] ?? 0) as int;
      totalWaktuLatihan.value = (data['totalDurasi'] ?? '').toString();
    } else {
      print('Gagal mengambil data histori: ${response.body}');
    }
  } catch (e) {
    print('Error saat mengambil total latihan: $e');
  }
}

  Future<void> fetchDashboardKehamilan() async {

  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('auth_token');
  final role = prefs.getString('user_role');

  if (token == null) return;

  String url = "${ApiConfig.baseUrl}/pregnancy/dashboard";

  /// jika pendamping ambil data pasangan
  if(role == "pendamping"){
    url = "${ApiConfig.baseUrl}/pregnancy/dashboard/pasangan";
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $token"
    }
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    usiaMinggu.value = data["usia_kehamilan_minggu"] ?? 0;
    usiaHari.value = data["usia_kehamilan_hari"] ?? 0;
    trimester.value = data["trimester"] ?? 0;
    hpl.value = data["hpl"] ?? "";
    
    hpht.value = data["hpht"] ?? "";
    tinggiBadan.value = data["tinggi_badan"]?.toString() ?? "";
    beratBadan.value = data["berat_badan"]?.toString() ?? "";
    riwayatPenyakit.value = data["riwayat_penyakit"] ?? "";

    ukuranJanin.value = data["ukuran_janin"] ?? "";
    perkembanganJanin.value = data["perkembangan_janin"] ?? "";
    tipsKesehatan.value = data["tips_kesehatan"] ?? "";

  } else {

    print("Dashboard pregnancy gagal: ${response.body}");

  }

}
}
