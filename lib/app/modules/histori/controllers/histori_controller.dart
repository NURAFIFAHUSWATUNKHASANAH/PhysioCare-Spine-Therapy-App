import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/app/modules/home/controllers/home_controller.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:pyhsiocare/app/modules/rekomendasi/views/rekomendasi_view.dart';

class HistoriController extends GetxController {
  var historyList = <Map<String, dynamic>>[].obs;
  var averageByLabel = <String, double>{}.obs;
  var listHistori = <RekomendasiDialog>[].obs;

  // Observable total latihan & waktu latihan
  var totalLatihan = 0.obs;
  var totalWaktuLatihan = "".obs;

  void clear() {
    listHistori.clear();
  }

Future<void> fetchHistory() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      print("User belum login");
      historyList.clear();
      return;
    }

    final url = ApiConfig.historiUrlByUser(userId);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data is List && data.isNotEmpty) {
        historyList.assignAll(
          data.map<Map<String, dynamic>>((item) => {
                "label": item["label"],
                "tanggal": item["tanggal"],
                "accuracy": item["accuracy"]
              }).toList(),
        );

        _calculateAverageByLabel();
        _updateTotalLatihanDanWaktu(data.length);
      } else {
        historyList.clear();
        totalLatihan.value = 0;
        totalWaktuLatihan.value = "0 menit";
      }
    } else {
      print("Failed load history");
    }
  } catch (e) {
    print("Error: $e");
  }
}

  void _calculateAverageByLabel() {
    Map<String, List<double>> grouped = {};

    for (var item in historyList) {
      final label = item['label'] ?? 'Gerakan';
      final accuracy = (item['accuracy'] ?? 0).toDouble();

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(accuracy);
    }

    averageByLabel.value = {
      for (var entry in grouped.entries)
        entry.key: entry.value.reduce((a, b) => a + b) / entry.value.length
    };
  }

  void _updateTotalLatihanDanWaktu(int jumlahSesi) {
    totalLatihan.value = jumlahSesi;

    final totalSeconds = jumlahSesi * 30; // 30 detik per sesi
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      totalWaktuLatihan.value = '$hours jam $minutes menit';
    } else {
      totalWaktuLatihan.value = '$minutes menit';
    }
    // Update ke HomeController
          final homeController = Get.find<HomeController>();
          homeController.totalLatihan.value = totalLatihan.value;
          homeController.totalWaktuLatihan.value = totalWaktuLatihan.value;
  }

  @override
  void onInit() {
    super.onInit();
    ApiConfig.init();
    fetchHistory();
  }
}
